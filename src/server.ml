open Lwt

type server_name = string
type inet_addr = string
type port = int
type socket_filename = string

let default_read_timeout = 60.
let default_write_timeout = 60.

let default_read_error_handler exn =
  let backtrace = Printexc.get_backtrace () in
  prerr_endline (Printexc.to_string exn ^ "\n" ^ backtrace);
  return {
    Response.status = `Internal_server_error;
    headers = [`Content_type "text/plain"];
    body = `String (Printexc.to_string exn);
  }

let default_write_error_handler exn =
  let backtrace = Printexc.get_backtrace () in
  prerr_endline (Printexc.to_string exn ^ "\n" ^ backtrace);
  return ()


let with_timeout timeout x =
  Lwt.pick [Lwt_unix.timeout timeout; x]


(*
   Handle a connection.
   A single request is processed, then the connection is closed.
*)
let handle_connection
    ~read_timeout
    ~write_timeout
    ~read_error_handler
    ~write_error_handler
    f inch ouch =

  let close_connection () =
    join [
      catch (fun () -> Lwt_io.close ouch) write_error_handler;
      catch (fun () -> Lwt_io.close inch) write_error_handler;
    ]
  in

  let process_request () =
    with_timeout read_timeout
      (Request.of_stream (Lwt_io.read_chars inch)) >>= fun request ->
    f request
  in

  let write_response response =
    let open Response in
    (* Add content length from body if not already in the headers *)
    let is_content_length_in_headers =
      List.exists
        (function `Content_length _ -> true | _ -> false)
        response.headers
    in
    let response_headers =
      if is_content_length_in_headers then
        response.headers
      else
        match response.body with
        | `Stream (Some l, _) ->
            `Content_length l :: response.headers
        | `String s ->
            `Content_length (String.length s) :: response.headers
        | `Stream (None, _) ->
            response.headers
    in

    (* Write headers *)
    Lwt_list.iter_s
      (fun h -> Lwt_io.write ouch (Http_header.to_string h))
      (`Status response.status :: response_headers)
    >>= fun () ->

    (* Blank line between headers and body *)
    Lwt_io.write ouch "\r\n" >>= fun () ->

    (* Write the body *)
    (match response.body with
     | `Stream (_, s) -> Lwt_io.write_chars ouch s
     | `String s      -> Lwt_io.write ouch s
    ) >>= fun () ->
    Lwt_io.flush ouch
  in

  catch
    (fun () ->
       catch
         process_request
         read_error_handler
       >>= fun response ->

       catch
         (fun () ->
            with_timeout write_timeout
              (write_response response)
         )
         write_error_handler
       >>= fun () ->

       close_connection ()
    )
    (fun _e ->
       close_connection ()
    )


let handler
    ~read_timeout
    ~write_timeout
    ~read_error_handler
    ~write_error_handler
    ~sockaddr
    ~name
    f =

  Lwt_io.establish_server sockaddr (fun (ic, oc) ->
    ignore_result (
      handle_connection
        ~read_timeout
        ~write_timeout
        ~read_error_handler
        ~write_error_handler
        f ic oc
    )
  )


let handler_inet
    ?(read_timeout = default_read_timeout)
    ?(write_timeout = default_write_timeout)
    ?(read_error_handler = default_read_error_handler)
    ?(write_error_handler = default_write_error_handler)
    name
    inet_addr
    port
    f =
    handler
      ~read_timeout
      ~write_timeout
      ~read_error_handler
      ~write_error_handler
      ~sockaddr: (Unix.ADDR_INET (Unix.inet_addr_of_string inet_addr, port))
      ~name f

let handler_sock
    ?(read_timeout = default_read_timeout)
    ?(write_timeout = default_write_timeout)
    ?(read_error_handler = default_read_error_handler)
    ?(write_error_handler = default_write_error_handler)
    name
    socket_filename
    f =
    handler
      ~read_timeout
      ~write_timeout
      ~read_error_handler
      ~write_error_handler
      ~sockaddr: (Unix.ADDR_UNIX socket_filename)
      ~name f
