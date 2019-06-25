open Lwt.Infix

let socket_filename = "ocaml-scgi-test.sock"

let (server_is_ready, notify_server_is_ready) = Lwt.wait ()

let request_handler req =
  Printf.printf "Server got request for path %S\n" (Scgi.Request.path req) ;
  match Scgi.Request.path req with
  | "/hello" ->
      Lwt.return
        { Scgi.Response.status= `Ok
        ; headers= [`Content_type "text/plain"]
        ; body= `String "Hello" }
  | _ ->
      Lwt.return
        { Scgi.Response.status= `Not_found
        ; headers= [`Content_type "text/plain"]
        ; body= `String "Not such path" }

let test_hello () =
  let req = Scgi.Request.make `GET (Uri.of_string "/hello") [] "" in
  Scgi.Client.request_sock ~socket_filename req >>= fun resp ->
  assert (resp.Scgi.Response.status = `Ok) ;
  assert (resp.Scgi.Response.body = `String "Hello") ;
  Lwt.return true

let test_not_found () =
  let req = Scgi.Request.make `GET (Uri.of_string "/not/a/path") [] "" in
  Scgi.Client.request_sock ~socket_filename req >>= fun resp ->
  assert (resp.Scgi.Response.status = `Not_found) ;
  assert (resp.Scgi.Response.body = `String "Not such path") ;
  Lwt.return true

let tests = [("hello", test_hello); ("not found", test_not_found)]

let string_of_exn e =
  let backtrace = Printexc.get_backtrace () in
  let s = Printexc.to_string e in
  s ^ "\n" ^ backtrace

let run_tests () =
  server_is_ready >>= fun _ ->
  Lwt_list.map_p
    (fun (name, f) ->
      Lwt.catch f (fun e ->
          let s = string_of_exn e in
          Printf.printf "Exception: %s\n%!" s ;
          Lwt.return false )
      >>= fun success -> Lwt.return (name, success) )
    tests
  >>= fun results ->
  List.iter
    (fun (name, success) ->
      Printf.printf "%-10s %s\n" (if success then "OK" else "ERROR") name )
    results ;
  let total_success = List.for_all (fun (_, success) -> success) results in
  Lwt.return total_success

let create_server request_handler =
  if Sys.file_exists socket_filename then Sys.remove socket_filename ;
  Scgi.Server.handler_sock socket_filename request_handler >>= fun _ ->
  Lwt.wakeup_later notify_server_is_ready () ;
  Lwt.return_unit

let main () =
  Printexc.record_backtrace true ;
  let _server = create_server request_handler in
  let tests = run_tests () in
  let success = Lwt_main.run tests in
  exit (if success then 0 else 1)

let () = main ()
