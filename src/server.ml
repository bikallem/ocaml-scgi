open Lwt

type server_name = string
type inet_addr = string
type port = int
type socket_filename = string

let default_read_error_handler exn =
  prerr_endline (Printexc.to_string exn ^ "\n" ^ Printexc.get_backtrace ());
  return
    { Response.status = `Internal_server_error;
      headers = [`Content_type "text/plain"];
      body = `String (Printexc.to_string exn);
    }

let default_write_error_handler exn =
  prerr_endline (Printexc.to_string exn ^ "\n" ^ Printexc.get_backtrace ());
  return ()

(*
   Handle a connection.
   A single request is processed, then the connection is closed.
*)
let handle_connection
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
    Request.of_stream (Lwt_io.read_chars inch) >>= fun request ->
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
        | `String s           ->
            `Content_length (String.length s) :: response.headers
        | `Stream (None, _)   -> response.headers
    in

    (* Write headers *)
    Lwt_util.iter
      (fun h -> Lwt_io.write ouch (Http_header.to_string h))
      (`Status response.status :: response_headers)
    >>= fun () ->

    (* Blank line between headers and body *)
    Lwt_io.write ouch "\r\n" >>= fun () ->

    (* Write the body *)
    match response.body with
    | `Stream (_, s) -> Lwt_io.write_chars ouch s
    | `String s      -> Lwt_io.write ouch s
  in

  catch
    (fun () ->
       catch
         process_request
         read_error_handler
       >>= fun response ->

       catch
         (fun () -> write_response response)
         write_error_handler
       >>= fun () ->

       close_connection ()
    )
    (fun _e ->
       close_connection ()
    )


let handler
    ~read_error_handler
    ~write_error_handler
    ~sockaddr
    ~name
    f =

  Lwt_io.establish_server sockaddr (fun (ic, oc) ->
    ignore_result (
      handle_connection
        ~read_error_handler
        ~write_error_handler
        f ic oc
    )
  )


let handler_inet
    ?(read_error_handler = default_read_error_handler)
    ?(write_error_handler = default_write_error_handler)
    name
    inet_addr
    port
    f =
    handler
      ~read_error_handler
      ~write_error_handler
      ~sockaddr: (Unix.ADDR_INET (Unix.inet_addr_of_string inet_addr, port))
      ~name f

let handler_sock
    ?(read_error_handler = default_read_error_handler)
    ?(write_error_handler = default_write_error_handler)
    name
    socket_filename
    f =
    handler
      ~read_error_handler
      ~write_error_handler
      ~sockaddr: (Unix.ADDR_UNIX socket_filename)
      ~name f
