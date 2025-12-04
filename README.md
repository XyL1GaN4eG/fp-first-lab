# Лабораторная работа №1 — Простые алгоритмы (OCaml)

[![CI](https://github.com/XyL1GaN4eG/fp-first-lab/actions/workflows/ci.yml/badge.svg)](https://github.com/XyL1GaN4eG/fp-first-lab/actions/workflows/ci.yml)

- Варианты:
  - Project Euler #7 — поиск 10 001-го простого числа;
  - Project Euler #24 — миллионная лексикографическая перестановка цифр `0..9`.

## Описание задачи

1) Euler #7: получить 10 001-е простое число, продемонстрировав разные приёмы ФП: хвостовая и обычная рекурсия, модульный конвейер с filter/fold, использование map, императивный синтаксис циклов и ленивые последовательности.
2) Euler #24: найти миллионную лексикографическую перестановку цифр `0..9`, показав факториадную декомпозицию, императивный алгоритм next-permutation и ленивые последовательности.

## Реализации (ключевые элементы)

- `lib/prime.ml` — утилиты для простых чисел: `is_prime`, ленивый генератор простых `primes_seq` и бесконечная последовательность целых `ints_from`.
- Решения задачи (модуль `Fp_first_lab.Euler7`):
  - `tail_recursive`: хвостовая рекурсия с аккумуляторами `count`/`last_prime`.
  - `plain_recursive`: немодернизированная рекурсия, которая строит список найденных простых и берёт последний элемент.
  - `modular_pipeline`: последовательность `ints_from 2 |> Seq.filter is_prime |> Seq.take n |> Seq.fold_left`.
  - `mapped_generation`: генерация пар через `map`, последующая фильтрация по признаку простоты и свёртка.
  - `loop_based`: императивный `while`-цикл для сравнения с традиционным стилем.
  - `lazy_seq_based`: работа с бесконечным ленивым списком простых (`primes_seq () |> Seq.take n`).
- Решения задачи (модуль `Fp_first_lab.Euler24`) — миллионная лексикографическая перестановка цифр `0..9`:
  - `tail_recursive`: факториадная схема с хвостовой рекурсией.
  - `plain_recursive`: классическая рекурсия без аккумуляторов.
  - `modular_pipeline`: конвейер на `fold` с выбором цифры по факториалу позиции.
  - `mapped_generation`: вычисление индексов выбора через `map`, затем свёртка по списку оставшихся цифр.
  - `loop_based`: императивный цикл с алгоритмом `next_permutation`.
  - `lazy_seq_based`: ленивый `Seq` из перестановок и выбор нужного элемента.
- CLI для ручной проверки: `dune exec bin/main.exe -- -p 7 -n 10001` или `-p 24 -n 1000000` (по умолчанию `-p 7`, `-n` берётся из задачи).

### Пример: хвостовая рекурсия

```ocaml
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
```

### Пример: факториадная позиция (Euler #24)

```ocaml
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
```

## Запуск и тестирование

- Сборка: `dune build`
- Автоформатирование: `dune fmt`
- Тесты (Alcotest): `dune test` — проверки по обоим задачам (простые числа и лексикографические перестановки) и обработка некорректного ввода.
- CLI: `dune exec bin/main.exe -- -p 7 -n 10001` или `dune exec bin/main.exe -- -p 24 -n 1000000` (параметры по умолчанию берутся из условий).

## CI/проверки качества

- GitHub Actions (`.github/workflows/ci.yml`) ставит OCaml 5.3, устанавливает зависимости из `fp_first_lab.opam` и последовательно выполняет:
  - автоформатирование: `dune fmt` + `git diff --exit-code` (провал, если есть неотформатированные изменения);
  - сборку: `dune build`;
  - тесты: `dune test`.
- Локально те же шаги можно запускать вручную перед коммитом.

## Выводы

- Наивная рекурсивная реализация быстро приводит к глубокой рекурсии, поэтому хвостовая версия — безопаснее по стеку.
- Конвейеры `Seq` с `filter`/`take`/`fold` позволяют выразить задачу декларативно без явных циклов.
- Использование `map` удобно для аннотирования данных в потоке без изменения остальной логики.
- Ленивые последовательности дают естественную работу с бесконечными списками; императивный цикл оставлен для сравнения с «традиционным» стилем.
