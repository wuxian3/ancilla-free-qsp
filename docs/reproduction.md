# Reproduction and provenance

## Imported source

The import uses Overleaf Git revision
`911f5e1e39cf6ada7e2a20676db0e38e38d5b9c3` (2026-09-11), retrieved on 2026-11-02.
The 27 manuscript, helper, table, evidence and editorial files under `paper/`
are the original Git blobs. Their SHA-256 hashes are listed in
[import-manifest.json](import-manifest.json).

Windows Git's automatic CRLF checkout conversion is not part of the source
artifact. Files were imported using their original LF Git-blob bytes so the
three evidence hashes match the historical `SOURCE_MAP.json`. `.gitattributes`
preserves LF in this repository.

The old project-specific synchronization helper and private Overleaf remote
address are not included. The new repository starts from a clean Git history;
no Overleaf credentials or remote configuration are copied. Repository preparation
does not push any changes back to Overleaf.

`paper/qsp_paper/editorial/BUILD_VALIDATION.json` records an earlier September
2026 build. It is retained as historical provenance, not as the current check log.
Likewise, the paper's statements about the research archive describe that original
work, not files distributed in this repository.

## Reproducible here

| Task | Command | What success establishes |
| --- | --- | --- |
| Formal proofs | `lake build` | The current Lean modules elaborate and are checked by Lean |
| Axiom closure | `python scripts/check_axioms.py` | Every declared project theorem uses only the allowed foundational axioms |
| Import/evidence integrity | `python scripts/check_repository.py` | Exact imported bytes and evidence hashes match the recorded sources |
| Table reproduction | Included in `check_repository.py` | Both tables regenerate from frozen summaries in an isolated copy |
| Manuscript build | `cd paper && bash build_qsp.sh` | pdfLaTeX/Biber can render the complete main manuscript |

Use the pinned `lean-toolchain` and `lake-manifest.json`. After installing elan,
`lake exe cache get` downloads compiled Mathlib dependencies. For a smaller cache,
the specific imported module names may be supplied to that command; this changes
neither the dependency versions nor the mathematical statements.

The table checker reads historical summaries. Matching their hashes proves
integrity relative to the imported records, not the truth of every numerical claim.

## Missing research artifacts

The manuscript cites `QSP-CYCLE13-REVIEW.zip`, whose `verify_cycle13.py` entry point
reportedly replayed 13 finite certificates and eight negative controls. The archive
was not retained and was not available during this import. This repository cannot
regenerate the original circuits or independently replay those certificates.

Do not claim that the library or CI validates the unavailable prototype, the exact
resource measurements, accepted target instances or the old negative controls.
Rebuilding that experimental pipeline would be a separate implementation with its
own provenance and validation, not a recovery of the missing archive.

## Authorship and public release

The original manuscript has an empty author field. No author list, affiliation or
venue has been inferred from the GitHub account. Complete those publication details
when known. Apache-2.0 is the repository's selected source license; confirm that it
is appropriate for all contributed material before a public release.
