# Cosmic_Energy.sh

One runtime file, two modes, one physical line, under 2048 bytes.

## Offline

No network access is required. The embedded Ω kernel checks fixed-point preservation, a literal tableau condition, reversible encoding, the one-fair-bit model, and the formal power invariant `x_n = c^(2/n)`.

```sh
sh Cosmic_Energy.sh 8
```

## Live

With network access, the same `Cosmic_Energy.sh` enumerates the public GitHub repositories of `letsgo0226`, recursively collects blob paths into a sorted manifest, and combines that manifest with the currently checked-out `Cosmic_Energy.sh` bytes and workflow bytes as one reversible system object. It also requires both the program and workflow paths to occur in the public manifest.

```sh
sh Cosmic_Energy.sh live letsgo0226
```

When available, `GITHUB_TOKEN` is used for authenticated GitHub API requests.

## GitHub Actions

`.github/workflows/cosmic-energy.yml` runs the same file in offline mode first and live mode second. It is triggered by:

- `*/5 * * * *` schedule;
- pushes to `main`;
- pull requests targeting `main`;
- `workflow_dispatch`;
- `repository_dispatch` type `cosmic-energy`.

The offline job also enforces `<2048 bytes` and one physical line.

## Boundary

The live manifest is a runtime snapshot of public repository/blob-path metadata, not a permanent copy of all repository contents. These are formal/computational certificates and self-inclusion checks; they do not establish an external physical law, physical zero entropy, the Riemann Hypothesis, or software control of physical systems.
