# Cosmic_Energy.sh

A single runtime file with two verification modes.

## Offline

No network access is required. The embedded Ω kernel checks its fixed-point, tableau, reversible encoding, fair-bit entropy model, and the formal power invariant `x_n = c^(2/n)`.

```sh
sh Cosmic_Energy.sh 8
# or
sh Cosmic_Energy.sh offline 8
```

## Live

With network access, the same file enumerates the public GitHub repositories of `letsgo0226`, builds a canonical blob manifest, verifies reversible encoding, and explicitly includes the checked-out `Cosmic_Energy.sh` and its GitHub Actions workflow in the verified system bytes. It also compares the local program/workflow bytes with the corresponding GitHub revision.

```sh
sh Cosmic_Energy.sh live letsgo0226
```

For authenticated GitHub API access, set `GITHUB_TOKEN` or `GH_TOKEN`.

## GitHub Actions

`.github/workflows/cosmic-energy.yml` runs:

- every 5 minutes via cron;
- on pushes to `main`;
- on pull requests targeting `main`;
- by `workflow_dispatch`;
- by `repository_dispatch` event type `cosmic-energy`.

The workflow first verifies offline mode, then executes live self-inclusive verification from the same `Cosmic_Energy.sh` file.

## Boundary

This repository implements formal/computational certificates and self-inclusion checks. It does not establish an external physical law, physical zero entropy, the Riemann Hypothesis, or a claim that software controls physical systems.
