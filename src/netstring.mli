(** Netstring implementation *)

(** Consume and decode a netstring from a stream *)
val decode : char Lwt_stream.t -> string Lwt.t

(** Encode a netstring: "abc" -> "3:abc," *)
val encode : string -> string
