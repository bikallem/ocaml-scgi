open Scgi;
open Lwt.Infix;

let socket_filename = "/tmp/scgi-test";

let request_handler = req => {
  switch (Request.path(req)) {
  | "/hello" =>
    Lwt.return({
      Response.status: `Ok,
      headers: [`Content_type("text/plain")],
      body: `String("Hello World!"),
    })
  | _ =>
    Lwt.return({
      Response.status: `Not_found,
      headers: [`Content_type("text/plain")],
      body: `String("No such path"),
    })
  };
};

let () = {
  if (Sys.file_exists(socket_filename)) {
    Sys.remove(socket_filename);
  };

  Server.handler_sock(socket_filename, request_handler)
  >>= (_ => fst(Lwt.wait()))
  |> Lwt_main.run;
};
