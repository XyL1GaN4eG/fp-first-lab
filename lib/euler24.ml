type solution = { id : string; description : string; solver : int -> string }

open Util

let digits = [ 0; 1; 2; 3; 4; 5; 6; 7; 8; 9 ]
let target_n = 1_000_000
let expected_answer = "2783915460"

let factorial n =
  let rec aux acc = function
    | m when m <= 1 -> acc
    | m -> aux (acc * m) (m - 1)
  in
  aux 1 n

let total_permutations = factorial (List.length digits)

let validate_n n =
  if n < 1 || n > total_permutations then
    invalid_arg "n must be within the range of available permutations"

let remove_at index lst =
  let rec aux i acc = function
    | [] -> invalid_arg "index out of bounds"
    | x :: xs ->
        if i = index then (x, List.rev_append acc xs)
        else aux (i + 1) (x :: acc) xs
  in
  aux 0 [] lst

let digits_to_string digits =
  let buf = Buffer.create (List.length digits) in
  List.iter (fun d -> Buffer.add_string buf (string_of_int d)) digits;
  Buffer.contents buf

let factorials =
  List.init (List.length digits) (fun i ->
      factorial (List.length digits - i - 1))

let tail_recursive n =
  validate_n n;
  let rec build idx pool acc =
    match pool with
    | [] -> digits_to_string (List.rev acc)
    | _ ->
        let fact = factorial (List.length pool - 1) in
        let choice = idx / fact in
        let remainder = idx mod fact in
        let picked, rest = remove_at choice pool in
        build remainder rest (picked :: acc)
  in
  build (n - 1) digits []

let plain_recursive n =
  validate_n n;
  let rec build idx pool =
    match pool with
    | [] -> []
    | _ ->
        let fact = factorial (List.length pool - 1) in
        let choice = idx / fact in
        let remainder = idx mod fact in
        let picked, rest = remove_at choice pool in
        picked :: build remainder rest
  in
  build (n - 1) digits |> digits_to_string

let modular_pipeline n =
  validate_n n;
  let _, _, acc =
    List.fold_left
      (fun (idx, pool, acc) fact ->
        match pool with
        | [] -> (idx, pool, acc)
        | _ ->
            let choice = idx / fact in
            let idx' = idx mod fact in
            let picked, rest = remove_at choice pool in
            (idx', rest, picked :: acc))
      (n - 1, digits, [])
      factorials
  in
  List.rev acc |> digits_to_string

let mapped_generation n =
  validate_n n;
  let idx = ref (n - 1) in
  let choices =
    List.map
      (fun fact ->
        let choice = !idx / fact in
        idx := !idx mod fact;
        choice)
      factorials
  in
  let _, acc =
    List.fold_left
      (fun (pool, acc) choice ->
        match pool with
        | [] -> (pool, acc)
        | _ ->
            let picked, rest = remove_at choice pool in
            (rest, picked :: acc))
      (digits, []) choices
  in
  List.rev acc |> digits_to_string

let swap arr i j =
  let tmp = arr.(i) in
  arr.(i) <- arr.(j);
  arr.(j) <- tmp

let reverse_sub arr start stop =
  let i = ref start in
  let j = ref stop in
  while !i < !j do
    swap arr !i !j;
    incr i;
    decr j
  done

let next_permutation_inplace arr =
  let n = Array.length arr in
  let i = ref (n - 2) in
  while !i >= 0 && arr.(!i) >= arr.(!i + 1) do
    decr i
  done;
  if !i < 0 then false
  else
    let j = ref (n - 1) in
    while arr.(!j) <= arr.(!i) do
      decr j
    done;
    swap arr !i !j;
    reverse_sub arr (!i + 1) (n - 1);
    true

let array_to_string arr =
  let buf = Buffer.create (Array.length arr) in
  Array.iter (fun d -> Buffer.add_string buf (string_of_int d)) arr;
  Buffer.contents buf

let loop_based n =
  validate_n n;
  let arr = Array.of_list digits in
  for _ = 1 to n - 1 do
    ignore (next_permutation_inplace arr)
  done;
  array_to_string arr

let permutations_seq () =
  let initial = Array.of_list digits in
  let rec step arr_opt () =
    match arr_opt with
    | None -> Seq.Nil
    | Some arr ->
        let current = Array.copy arr in
        let next = if next_permutation_inplace arr then Some arr else None in
        Seq.Cons (array_to_string current, step next)
  in
  step (Some initial)

let lazy_seq_based n =
  validate_n n;
  permutations_seq () |> nth_from_seq n

let solutions =
  [
    {
      id = "tail-rec";
      description = "Tail-recursive factoradic selection";
      solver = tail_recursive;
    };
    {
      id = "plain-rec";
      description = "Plain recursion without accumulators";
      solver = plain_recursive;
    };
    {
      id = "modular";
      description = "Fold-based factoradic pipeline";
      solver = modular_pipeline;
    };
    {
      id = "map-based";
      description = "Map to compute factoradic choices, then fold";
      solver = mapped_generation;
    };
    {
      id = "loop";
      description = "Imperative next-permutation loop";
      solver = loop_based;
    };
    {
      id = "lazy-seq";
      description = "Lazy sequence over lexicographic permutations";
      solver = lazy_seq_based;
    };
  ]
