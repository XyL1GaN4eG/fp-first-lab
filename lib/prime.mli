val is_prime : int -> bool
(** [is_prime n] returns [true] when [n] is a prime number. *)

val next_prime : int -> int
(** [next_prime n] returns the first prime greater than or equal to [n]. *)

val ints_from : int -> int Seq.t
(** Lazy infinite sequence of integers starting from [start]. *)

val primes_seq : unit -> int Seq.t
(** Lazy infinite sequence of prime numbers. *)
