open Fp_first_lab

type problem = Seven | Twenty_four

let () =
  let problem = ref Seven in
  let n_override = ref None in
  let set_problem = function
    | "7" -> problem := Seven
    | "24" -> problem := Twenty_four
    | other -> raise (Arg.Bad (Printf.sprintf "Unknown problem: %s" other))
  in
  let set_n v = n_override := Some v in
  let specs =
    [
      ("-p", Arg.String set_problem, "Problem number: 7 (default) or 24");
      ("--problem", Arg.String set_problem, "Problem number: 7 (default) or 24");
      ("-n", Arg.Int set_n, "Override N (prime index or permutation number)");
      ("--n", Arg.Int set_n, "Override N (prime index or permutation number)");
    ]
  in
  Arg.parse specs (fun _ -> ()) "Euler playground";
  match !problem with
  | Seven ->
      let open Euler7 in
      let n = match !n_override with Some v -> v | None -> target_n in
      solutions
      |> List.iter (fun solution ->
          let answer = solution.solver n in
          Printf.printf "%s (%s): %d\n" solution.id solution.description answer);
      Printf.printf "Expected answer for %d: %d\n" target_n expected_answer
  | Twenty_four ->
      let open Euler24 in
      let n = match !n_override with Some v -> v | None -> target_n in
      solutions
      |> List.iter (fun solution ->
          let answer = solution.solver n in
          Printf.printf "%s (%s): %s\n" solution.id solution.description answer);
      Printf.printf "Expected answer for %d: %s\n" target_n expected_answer
