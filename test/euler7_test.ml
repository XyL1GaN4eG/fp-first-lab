open Fp_first_lab
open Euler7

let prime_checks =
  [ (2, true); (3, true); (4, false); (17, true); (21, false); (97, true) ]

let make_solution_case { Euler7.id; solver; _ } =
  let test () =
    Alcotest.check Alcotest.int (id ^ " -> 1st prime") 2 (solver 1);
    Alcotest.check Alcotest.int (id ^ " -> 6th prime") 13 (solver 6);
    Alcotest.check Alcotest.int (id ^ " -> 10001st prime") expected_answer
      (solver target_n)
  in
  (id, `Quick, test)

let invalid_argument_case =
  let test () =
    Alcotest.check_raises "n must be positive"
      (Invalid_argument "n must be a positive index for a prime number")
      (fun () -> ignore (tail_recursive 0))
  in
  ("invalid-argument", `Quick, test)

let () =
  Alcotest.run "Euler #7"
    [
      ( "prime-check",
        [
          ( "is_prime samples",
            `Quick,
            fun () ->
              List.iter
                (fun (n, expected) ->
                  Alcotest.check Alcotest.bool
                    (Printf.sprintf "is_prime %d" n)
                    expected (Prime.is_prime n))
                prime_checks );
        ] );
      ( "solutions",
        invalid_argument_case :: List.map make_solution_case solutions );
    ]
