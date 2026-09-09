# Cosmic_Energy.sh

One runtime file, one physical line, **2041 bytes**, with offline and live modes.

## Exact offline calculation

The old floating-point check could reject a valid finite stage because of rounding. The offline branch now uses arbitrary-precision integers and an exact positive-root representation. It does not call `exp`, `log`, or a floating-point tolerance.

Let `a = 299792458`. For a positive integer stage `n`, the program computes:

```text
g = gcd(2, n)
r = a ** (2 // g)
d = n // g
x_n = the unique positive real d-th root of r
```

The JSON field `"x_n": [r, d]` represents that exact algebraic number. It is not a decimal estimate or an interval.

| n | x_n field | Exact value |
| --- | --- | --- |
| 1 | [89875517873681764, 1] | 89875517873681764 |
| 2 | [299792458, 1] | 299792458 |
| 3 | [89875517873681764, 3] | cube root of 89875517873681764 |
| 9086 | [299792458, 4543] | positive 4543rd root of 299792458 |

The integer certificate checks `r > 1`, `n % d == 0`, and:

```text
r ** (n // d) == a * a == 89875517873681764
```

Since `n/d = g`, the certificate establishes `x_n^n = a^2` using integer arithmetic. Positivity of the selected root and `r > 1` establish `x_n > 1`. Most stages have irrational values, so an exact finite representation is a root expression, not a finite decimal expansion.

This changes the JSON schema: `x_n` was a floating-point number and is now the pair `[radicand, degree]`. Consumers must support arbitrary-precision JSON integers; JavaScript's default number type can round large integer literals.

## Usage

```sh
# Eight stages, beginning at n=1; no network required.
sh Cosmic_Energy.sh 8

# One exact stage at the former failure point.
sh Cosmic_Energy.sh 1 9086

# One exact stage at a huge integer index.
sh Cosmic_Energy.sh 1 1000000000000000000

# Live public-repository manifest; owner defaults to letsgo0226.
sh Cosmic_Energy.sh live letsgo0226
sh Cosmic_Energy.sh live
```

The offline arguments are `COUNT [START]`, with defaults `8 1`. `COUNT=0` continues until interrupted or an execution/resource limit is reached. Negative counts and nonpositive starting stages are rejected. A run beginning at `START` constructs a fresh history segment; it does not claim to have executed earlier stages. Python 3 is required.

## Analytic unit limit

For every finite positive `n`:

```text
x_n = a^(2/n) > 1
x_n^n = a^2
lim(n -> infinity) x_n = 1
```

The output `x_O=1` is the analytic boundary value. It is not a finite-stage equality and is not proved merely by checking that a JSON field equals 1.

A proof avoiding numerical logarithms is available. Set `t_n = x_n - 1 > 0`. Bernoulli's inequality gives:

```text
a^2 = (1 + t_n)^n >= 1 + n*t_n
0 < t_n <= (a^2 - 1)/n -> 0
```

Thus, for a positive rational tolerance `epsilon = p/q`, the integer condition

```text
n >= ceil(q * (a^2 - 1) / p)
```

is a sufficient, exactly calculable bound. It is not asserted to be the smallest such stage.

The base `a` and degree remain in the finite representation. The single limiting value `1` alone cannot recover the original base. Here `a` is a dimensionless numerical constant; any physical interpretation needs a separate model and appropriate units.

## Reversible core and bit model

The existing sentinel-byte integer encoding and inverse are preserved, as are the fixed core projection and literal tableau-membership condition. That literal condition is not a general modal-logic prover.

One bit is sampled per execution and reused. Both `BIT=0` and `BIT=1` are valid. Under the assumed fair distribution, the source bit has model entropy 1 bit; the emitted bit value is not itself an entropy measurement.

The program still builds a growing history. Exact arithmetic removes floating-point failure, but does not supply unlimited memory, unlimited time, or an infinite completed execution.

## Live scope

Live mode enumerates public repositories and their default-branch blob paths, sorts the path manifest, and combines it with the local `Cosmic_Energy.sh` and workflow bytes for a reversible-carrier check. It requires both paths to occur in the remote manifest and rejects reported tree truncation or repository read errors.

Run live mode from the repository root with the workflow present. `GITHUB_TOKEN` is used when available. Modes are explicitly selected; there is no automatic network-detection fallback.

The compact live branch checks path membership and local-byte roundtrips. It does not compare local source bytes against a pinned remote revision or verify every repository's behavior. The full source review recorded below is an audit performed for this change, not an additional live runtime capability.

## Source review

The review enumerated **138 public repositories** and their default-branch trees, read **896 text files** by immutable blob SHA, and matched every returned UTF-8 byte count to GitHub's blob size. Two audio files were inventoried without source-text analysis.

The **371 .sh/.py/.go files** and **177 additional files containing code or code examples** were classified for relevant computational patterns. These are file counts, not counts of distinct programs. Static classification and focused source review do not establish semantic correctness of every program.

See [SOURCE_REVIEW.md](SOURCE_REVIEW.md) and [source-review.json](source-review.json) for the scope, source links, and complete file inventory. The embedded `K` remains a symbolic seed; the 2041-byte runtime does not contain the account's entire source corpus.

## GitHub Actions

The workflow retains the five-minute cron expression, pushes and pull requests targeting `main`, manual dispatch, and `repository_dispatch` type `cosmic-energy`. GitHub scheduled runs may be delayed; they are not a hard real-time timer.

The offline job checks the one-line byte budget, exact root certificates, stages around 9086, huge integer indices, invalid domains, both bit outcomes, and reversible encoding edge cases. The live job follows using the same runtime file.

Each scheduled execution starts its own finite sequence; stages do not accumulate across runs.

These checks establish the stated finite computational properties. They do not establish physical zero entropy, an external energy law, or a universal solution method.
