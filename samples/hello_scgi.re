open Scgi;

let () = {
  /* Command line options */
  let port = ref(1025);
  let addr = ref("127.0.0.1");
  let req_count = ref(0);
  Arg.parse(
    Arg.align([
      (
        "--port",
        Arg.Set_int(port),
        Printf.sprintf(" port number (default: %d)", port^),
      ),
      (
        "--addr",
        Arg.Set_string(addr),
        Printf.sprintf(" ip address to bind (default: %s)", addr^),
      ),
    ]),
    s => failwith(Printf.sprintf("Unknown argument: [%s]", s)),
    "try --help",
  );

  let _server =
    Server.handler_inet(
      addr^,
      port^,
      r => {
        incr(req_count);
        let s = string_of_int(req_count^);
        let body =
          Printf.sprintf(
            "%s. Hello world from Reason SCGI. The request path is: %s",
            s,
            Request.path(r),
          );
        Lwt.return({
          Response.status: `Ok,
          headers: [`Content_type("text/plain")],
          body: `String(body),
        });
      },
    );

  Lwt_main.run(fst(Lwt.wait()));
};
