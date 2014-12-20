(** SCGI client *)

val request_inet :
  server_name: string ->
  inet_addr: string ->
  port: int ->
  Request.t -> string Lwt.t

val request_sock :
  server_name: string ->
  socket_filename: string ->
  Request.t -> string Lwt.t
