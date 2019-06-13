type t = [`DELETE | `GET | `HEAD | `OPTIONS | `PATCH | `POST | `PUT]
(** HTTP request method *)

val of_string : string -> t

val to_string : t -> string
