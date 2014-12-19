(** Tests for the scgi module *)
open Test_common
open Scgi.Compatibility
open Lwt

let mock_request () =
  let null = Char.chr 0 in
  let b = Buffer.create 200 in
  Buffer.add_string b "70:";
  Buffer.add_string b "CONTENT_LENGTH";
  Buffer.add_char   b null;
  Buffer.add_string b "27";
  Buffer.add_char   b null;
  Buffer.add_string b "SCGI";
  Buffer.add_char   b null;
  Buffer.add_string b "1";
  Buffer.add_char   b null;
  Buffer.add_string b "REQUEST_METHOD";
  Buffer.add_char   b null;
  Buffer.add_string b "POST";
  Buffer.add_char   b null;
  Buffer.add_string b "REQUEST_URI";
  Buffer.add_char   b null;
  Buffer.add_string b "/deepthought";
  Buffer.add_char   b null;
  Buffer.add_string b ",";
  Buffer.add_string b "What is the answer to life?";
  Buffer.contents b

let tests =
  ["scgi_header", (fun () ->
     let result = Scgi.Scgi_headers.of_string (mock_request ()) in
     assert_int "same length list" (List.length result) 4
   );
   "scgi_request", (fun () ->
     Scgi.Scgi_request.of_stream (Lwt_stream.of_string (mock_request ()))
     >>= fun r ->
     let open Scgi.Scgi_request in
     assert_int "content_length" 27 (content_length r) >>= fun () ->
     assert_equal
       ~printer:Scgi.Http_method.to_string
       ~msg:"method"
       ~expected:`POST
       (meth r)
     >>= fun () ->
     assert_string "uri" "/deepthought" (path r) >>= fun () ->
     let body = contents r in
     assert_string ~msg:"content" ~expected:"What is the answer to life?" body
   );
  ]

let () = run tests
