open Prime

type solution = { id : string; description : string; solver : int -> int }

let target_n = 10_001
let expected_answer = 104_743

let validate_n n =
  if n < 1 then invalid_arg "n must be a positive index for a prime number"

let tail_recursive n =
  validate_n n;
  let rec search count candidate last_prime =
    if count = n then last_prime
    else
      let next_count, next_last =
        if is_prime candidate then (count + 1, candidate)
        else (count, last_prime)
      in
      search next_count (candidate + 1) next_last
  in
  search 0 2 0

let plain_recursive n =
  validate_n n;
  let rec collect left candidate =
    if left = 0 then []
    else
      let prime = is_prime candidate in
      let rest = collect (if prime then left - 1 else left) (candidate + 1) in
      if prime then candidate :: rest else rest
  in
  collect n 2 |> List.rev |> List.hd

let modular_pipeline n =
  validate_n n;
  ints_from 2 |> Seq.filter is_prime |> Seq.take n
  |> Seq.fold_left (fun _ prime -> prime) 0

let mapped_generation n =
  validate_n n;
  ints_from 2
  |> Seq.map (fun candidate -> (candidate, is_prime candidate))
  |> Seq.filter snd |> Seq.take n
  |> Seq.fold_left (fun _ (prime, _) -> prime) 0

let loop_based n =
  validate_n n;
  let count = ref 0 in
  let candidate = ref 2 in
  let last_prime = ref 0 in
  while !count < n do
    if is_prime !candidate then (
      incr count;
      last_prime := !candidate);
    incr candidate
  done;
  !last_prime

let lazy_seq_based n =
  validate_n n;
  primes_seq () |> Seq.take n |> Seq.fold_left (fun _ prime -> prime) 0

let solutions =
  [
    {
      id = "tail-rec";
      description = "Tail-recursive monolithic loop";
      solver = tail_recursive;
    };
    {
      id = "plain-rec";
      description = "Non-tail recursion building the result list";
      solver = plain_recursive;
    };
    {
      id = "modular";
      description = "Pipeline with generation, filter, fold";
      solver = modular_pipeline;
    };
    {
      id = "map-based";
      description = "Annotate candidates with map, then filter/fold";
      solver = mapped_generation;
    };
    {
      id = "loop";
      description = "Imperative for/while syntax";
      solver = loop_based;
    };
    {
      id = "lazy-seq";
      description = "Infinite lazy prime sequence";
      solver = lazy_seq_based;
    };
  ]
