type solution = { id : string; description : string; solver : int -> int }

val target_n : int
val expected_answer : int
val tail_recursive : int -> int
val plain_recursive : int -> int
val modular_pipeline : int -> int
val mapped_generation : int -> int
val loop_based : int -> int
val lazy_seq_based : int -> int

val solutions : solution list
(** All available implementations. *)
