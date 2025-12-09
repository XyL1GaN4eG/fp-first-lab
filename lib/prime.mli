(** [is_prime n] returns [true] when [n] is a prime number. *)
val is_prime : int -> bool

(** [next_prime n] returns the first prime greater than or equal to [n]. *)
val next_prime : int -> int

(** Lazy infinite sequence of integers starting from [start]. *)
val ints_from : int -> int Seq.t

(** Lazy infinite sequence of prime numbers. *)
val primes_seq : unit -> int Seq.t
