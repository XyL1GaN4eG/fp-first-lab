type solution = { id : string; description : string; solver : int -> string }

val target_n : int
val expected_answer : string
val tail_recursive : int -> string
val plain_recursive : int -> string
val modular_pipeline : int -> string
val mapped_generation : int -> string
val loop_based : int -> string
val lazy_seq_based : int -> string

val solutions : solution list
(** All available implementations. *)
