type t = [`DELETE | `GET | `HEAD | `OPTIONS | `PATCH | `POST | `PUT]
(** HTTP request method *)

let of_string = function
  | "DELETE" -> `DELETE
  | "GET" -> `GET
  | "HEAD" -> `HEAD
  | "OPTIONS" -> `OPTIONS
  | "PATCH" -> `PATCH
  | "POST" -> `POST
  | "PUT" -> `PUT
  | s -> failwith ("Invalid request method: " ^ s)

let to_string = function
  | `DELETE -> "DELETE"
  | `GET -> "GET"
  | `HEAD -> "HEAD"
  | `OPTIONS -> "OPTIONS"
  | `PATCH -> "PATCH"
  | `POST -> "POST"
  | `PUT -> "PUT"
