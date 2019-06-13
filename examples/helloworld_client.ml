open Scgi
open Lwt.Infix

let socket_filename = "/tmp/scgi-test"

let () =
  let req = Request.make `GET (Uri.of_string "/hello") [] "" in
  Client.request_sock ~socket_filename req
  >>= (fun _ ->
        Printf.printf "Got response\n" ;
        Lwt.return_unit)
  |> Lwt_main.run
