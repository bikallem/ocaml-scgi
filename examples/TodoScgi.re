open Scgi;

let port = ref(1025);
let addr = ref("127.0.0.1");
let req_count = ref(0);

let getTodo = (r: Request.t) => {
  open Printf;
  open Tyxml.Html;

  let meth = Request.meth(r) |> Http_method.to_string;
  let path = Request.path(r);
  let requestDetails =
    sprintf("HTTP Method: %s, Path: %s.\nAll todo done.", meth, path);

  let todoSection =
    main(
      ~a=[a_style("margin:0 auto; width: 500px")],
      [
        h1(
          ~a=[a_style("text-align:center")],
          [txt("Todos: " ++ requestDetails)],
        ),
        input(
          ~a=[
            a_style("width:100%"),
            a_placeholder("What needs to be done?"),
          ],
          (),
        ),
      ],
    );

  let todoPage =
    html(
      head(title(txt("Todo MVC in Native ReasonML")), []),
      body(~a=[a_style("font-family:arial, sans-serif")], [todoSection]),
    );

  let body = Format.asprintf("%a", pp(~indent=true, ()), todoPage);

  Lwt.return({
    Response.status: `Ok,
    headers: [`Content_type("text/html")],
    body: `String(body),
  });
};

let requestRouter = r => {
  incr(req_count);
  switch (Request.meth(r), Request.path(r)) {
  | (`GET, "/todo") => getTodo(r)
  | _ =>
    let s = string_of_int(req_count^);
    let body =
      Printf.sprintf(
        "Request #%s. Unhandled route - path is: %s, http method is: %s",
        s,
        Request.path(r),
        Request.meth(r) |> Http_method.to_string,
      );
    Lwt.return({
      Response.status: `Ok,
      headers: [`Content_type("text/plain")],
      body: `String(body),
    });
  };
};

let () = {
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

  let _server = Server.handler_inet(addr^, port^, requestRouter);

  Lwt_main.run(fst(Lwt.wait()));
};
