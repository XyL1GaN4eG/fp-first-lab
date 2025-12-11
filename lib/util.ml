let nth_from_seq n seq =
  seq |> Seq.drop (n - 1) |> Seq.uncons |> function
  | Some (value, _) -> value
  | None -> invalid_arg "sequence is shorter than expected"
