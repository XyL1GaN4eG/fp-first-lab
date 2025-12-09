#!/usr/bin/env python3
"""
Reference implementations of Project Euler #7 and #24 in Python.
Used to cross-check the OCaml solutions with a straightforward imperative style.
"""

from __future__ import annotations

import argparse
import math
from itertools import count, islice
from typing import Iterable, Iterator, List


def is_prime(n: int) -> bool:
    """Return True when n is a prime number."""
    if n < 2:
        return False
    limit = int(math.isqrt(n))
    for divisor in range(2, limit + 1):
        if n % divisor == 0:
            return False
    return True


def primes() -> Iterator[int]:
    """Lazy infinite generator of prime numbers."""
    return (candidate for candidate in count(2) if is_prime(candidate))


def nth_prime(n: int) -> int:
    """Return the n-th prime number (1-based)."""
    if n < 1:
        raise ValueError("n must be a positive index for a prime number")
    # Skip the first n-1 primes and take the next one.
    return next(islice(primes(), n - 1, n))


def nth_permutation(n: int, digits: Iterable[int] | None = None) -> str:
    """Return the n-th lexicographic permutation of the given digits."""
    pool: List[int] = list(digits if digits is not None else range(10))
    total = math.factorial(len(pool))
    if n < 1 or n > total:
        raise ValueError("n must be within the range of available permutations")

    idx = n - 1
    result: List[str] = []
    for remaining in range(len(pool), 0, -1):
        fact = math.factorial(remaining - 1)
        choice, idx = divmod(idx, fact)
        result.append(str(pool.pop(choice)))
    return "".join(result)


def main() -> None:
    parser = argparse.ArgumentParser(description="Python helpers for Euler #7/#24")
    parser.add_argument(
        "-p",
        "--problem",
        choices=["7", "24"],
        default="7",
        help="Problem number: 7 (default) or 24",
    )
    parser.add_argument(
        "-n",
        type=int,
        help="Override N (prime index or permutation number)",
    )
    args = parser.parse_args()

    if args.problem == "7":
        n = args.n if args.n is not None else 10_001
        print(nth_prime(n))
    else:
        n = args.n if args.n is not None else 1_000_000
        print(nth_permutation(n))


if __name__ == "__main__":
    main()
