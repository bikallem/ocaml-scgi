open Lwt

let sock_send sock s =
  let oc = Lwt_io.of_fd ~mode:Lwt_io.output sock in
  Lwt_io.write oc s

let sock_receive sock =
  let ic = Lwt_io.of_fd ~mode:Lwt_io.input sock in
  Lwt_io.read ic

let send_request sock req =
  sock_send sock (Request.to_string req)

(* Raw HTTP response *)
let receive_response sock =
  sock_receive sock

let request_inet
  ~server_name
  ~inet_addr
  ~port
  req =

  let sock = Lwt_unix.socket Unix.PF_INET Unix.SOCK_STREAM 0 in
  let finally_ () = Lwt_unix.close sock in
  catch
    (fun () ->
       Lwt_unix.gethostbyname server_name >>= fun hentry ->
       if Array.length hentry.Unix.h_addr_list <= 0 then
         assert false;
       Lwt_unix.connect sock
         (Unix.ADDR_INET (hentry.Unix.h_addr_list.(0), port))
       >>= fun () ->
       send_request sock req >>= fun () ->
       receive_response sock >>= fun response ->
       finally_ () >>= fun () ->
       return response
    )
    (fun e ->
       finally_ () >>= fun () ->
       raise e
    )

let request_sock
  ~server_name
  ~socket_filename
  req =

  let sock = Lwt_unix.socket Unix.PF_UNIX Unix.SOCK_STREAM 0 in
  let finally_ () = Lwt_unix.close sock in
  catch
    (fun () ->
       Lwt_unix.connect sock (Unix.ADDR_UNIX socket_filename) >>= fun () ->
       send_request sock req >>= fun () ->
       receive_response sock >>= fun response ->
       finally_ () >>= fun () ->
       return response
    )
    (fun e ->
       finally_ () >>= fun () ->
       raise e
    )
