let is_prime n =
  let limit = int_of_float (Float.sqrt (float_of_int n)) in
  let rec loop divisor =
    if divisor > limit then true
    else if n mod divisor = 0 then false
    else loop (divisor + 1)
  in
  n > 1 && loop 2

let rec next_prime n = if is_prime n then n else next_prime (n + 1)
let ints_from start = Seq.unfold (fun i -> Some (i, i + 1)) start

let primes_seq () =
  let rec step candidate () =
    if is_prime candidate then Seq.Cons (candidate, step (candidate + 1))
    else step (candidate + 1) ()
  in
  step 2
