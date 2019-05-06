open Scgi;
open Lwt.Infix;

let socket_filename = "/tmp/scgi-test";

let () = {
  let req = Request.make(`GET, Uri.of_string("/hello"), [], "");
  Client.request_sock(~socket_filename, req)
  >>= (
    _resp => {
      Printf.printf("Got response\n");
      Lwt.return_unit;
    }
  )
  |> Lwt_main.run;
};
