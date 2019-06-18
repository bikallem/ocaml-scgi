type t = [
  | `Content_length(int)
  | `Content_type(string)
  | `Location(Uri.t)
  | `Set_cookie(string)
  | `Status(Http_status.t)
  | `Other(string, string)
];

let to_string: t => string;
