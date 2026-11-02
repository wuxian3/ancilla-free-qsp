# Ancilla-Free Sparse Quantum State Preparation

Source and selected Lean 4 proofs for **Ancilla-Free Sparse Quantum State
Preparation: Simultaneous Depth and Gate-Count Bounds with Error Certification**.

The paper studies exact preparation on the output register alone, with simultaneous
depth and gate-count bounds, and a separate a posteriori target-error guarantee.
It is a research draft. **The main asymptotic theorem is not fully formalized.**
The Lean library proves selected supporting identities and error estimates under
the hypotheses written in each theorem; see the [proof map](docs/formalization.md).

## Contents

| Path | Contents |
| --- | --- |
| `paper/qsp_paper.tex` | Main manuscript; original source preserved |
| `paper/qsp_paper/sections/` | Mathematical construction and error certification |
| `paper/qsp_paper/evidence/` | Three frozen historical result summaries |
| `QSP/` | Lean proofs, over finite binary registers and complex inner-product spaces |
| `docs/formalization.md` | Paper-to-Lean correspondence, assumptions and remaining gaps |
| `docs/reproduction.md` | What can be reproduced and what cannot |
| `scripts/` | Provenance, table and theorem-axiom checks |

## Check the Lean proofs

Install [Lean through elan](https://lean-lang.org/install/), Python 3.11 or later,
and Git. From this repository's root:

```sh
lake exe cache get
lake build
python scripts/check_axioms.py
python scripts/check_repository.py
```

`lean-toolchain` pins Lean **4.24.0**. `lakefile.toml` and `lake-manifest.json`
pin Mathlib and its transitive dependencies. The axiom audit permits only
`propext`, `Classical.choice`, and `Quot.sound`; it rejects proof holes, new
axioms and native evaluation axioms in the theorem dependency closures.

The build checks universal statements, not a sample of circuit sizes.
The source check is complementary to Lean and the axiom audit.
The initial local build checked 21 theorems; see the
[validation record](docs/validation.md) for the exact scope and environment.

## Build the paper

With TeX Live, pdfLaTeX and Biber installed:

```sh
cd paper
bash build_qsp.sh
```

The result is `paper/qsp_paper.pdf`. For Overleaf, upload the contents of `paper/`,
set `qsp_paper.tex` as the main document, and select pdfLaTeX. To regenerate tables:

```sh
python paper/qsp_paper/generate_tables.py
```

Successful GitHub manuscript jobs also upload a `manuscript-pdf` workflow artifact.

The original manuscript and its historical editorial records are retained as a
snapshot; their September 2026 validation statements describe that earlier work.
This repository's new Lean proofs do not retroactively turn those records into a
claim that the whole paper has been formalized.

## Reproduction limits

The original `QSP-CYCLE13-REVIEW.zip` was not retained. Its circuit constructors,
13 certificates, verifier and eight negative controls are **not present** here.
The numerical tables can be regenerated from the supplied JSON summaries, but
the underlying experiments and certificates cannot be replayed from this repository.
The new Lean library is independent of that lost implementation. No historical
result is presented as a newly executed experiment.

## License and attribution

Unless a file states otherwise, repository source content is provided under [Apache-2.0](LICENSE). Lean,
Mathlib and other fetched dependencies retain their own licenses and attribution.
The manuscript leaves its author list blank; this import does not infer authors,
affiliations, a publication venue, peer review or historical priority.

See [provenance](docs/reproduction.md) for the source revision and imported file
hashes, and [中文说明](README.zh-CN.md) for a brief Chinese overview.
