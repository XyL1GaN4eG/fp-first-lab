open Fp_first_lab
open Euler24

let ascending = "0123456789"
let descending = "9876543210"
let total = 3_628_800

let make_solution_case { Euler24.id; solver; _ } =
  let test () =
    Alcotest.check Alcotest.string
      (id ^ " -> 1st permutation")
      ascending (solver 1);
    Alcotest.check Alcotest.string (id ^ " -> 1,000,000th") expected_answer
      (solver target_n);
    Alcotest.check Alcotest.string
      (id ^ " -> last permutation")
      descending (solver total)
  in
  (id, `Quick, test)

let invalid_argument_cases =
  [
    ( "n must be positive",
      `Quick,
      fun () ->
        Alcotest.check_raises "n must be positive"
          (Invalid_argument
             "n must be within the range of available permutations") (fun () ->
            ignore (tail_recursive 0)) );
    ( "n must be <= 10!",
      `Quick,
      fun () ->
        Alcotest.check_raises "n too large"
          (Invalid_argument
             "n must be within the range of available permutations") (fun () ->
            ignore (tail_recursive (total + 1))) );
  ]

let () =
  Alcotest.run "Euler #24"
    [
      ("invalid-argument", invalid_argument_cases);
      ("solutions", List.map make_solution_case solutions);
    ]
