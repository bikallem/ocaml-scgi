open Test_common
(** Tests for the netstring module *)

open Lwt
open Scgi

let tests =
  [ ( "decode"
    , fun () ->
        let stream = Lwt_stream.of_string "12:hello world!," in
        Netstring.decode stream >>= fun s ->
        assert_string ~msg:"12:hello world!" "hello world!" s ) ]

let _ = run tests
