# Source and editorial mapping

## Translation source

This English edition is based on the existing `QSP-Overleaf-Manuscript.zip` in the conversation. It translates and retypesets that manuscript rather than introducing new research results or refreshing the literature audit.

| Manuscript component | Archived research source | Treatment in this revision |
|---|---|---|
| Model, main theorem, small-support core, reconstruction, Householder lifting, lower bounds | Consolidated Cycle10 manuscript and proofs, as incorporated in the prior source package | English translation with the same definitions, quantifiers, formulas, labels, and candidate status |
| Exact reflection alternatives and joint resource guard | Cycle11 proof and results | English main-text comparison and implementation appendix |
| Compilation error, AQFT truncation, dyadic-pi rounding, paired inverses | Cycle12 proof and results | English finite-precision section, with distinct norms and per-execution accounting |
| Explicit rational targets, a posteriori source residual, interval propagation, acceptance | Cycle13 proof and results | English acceptance theorem, kernel appendix, and input limits |
| Prior work | The prior package's 11 bibliography entries | Citation keys and source identifiers retained; bibliography notes translated |

The standard `article` class replaces `ctexart`. The preamble uses pdfLaTeX, T1 font encoding, English language settings, and TeX Live's Latin Modern fonts. Chinese theorem and algorithm labels, captions, metadata, comments, and helper messages are replaced with English. No custom font files are delivered.

## Numerical provenance

The exact-reflection table uses identical-target rows from Cycle11's `finite_resources`. The target-error table uses Cycle13's `historical_rows`. Selection remains explicit in `generate_tables.py`; equal `(n,d)` values in different research cycles do not establish identical targets.

The three JSON summaries and `evidence/SOURCE_MAP.json` are copied without changing their bytes. Numerical table rows are compared against the previous tables. Upper-bound displays continue to round upward, while certificate acceptance refers to the underlying rational bounds, not the rendered decimals.

## Verification performed for this revision

Current checks concern English-only source content, unchanged evidence hashes and table values, preservation of cross-reference labels and bibliography keys, local pdfLaTeX/Biber compilation, rendered-page inspection, and a fresh extraction/build of the delivery package. Detailed results are recorded in `BUILD_VALIDATION.json`.

Historical circuit and certificate validation results are retained as archived research evidence. This revision does not claim to have rerun all experiments, rerun the research certificate suite, or performed an additional novelty audit. The optional local synchronization script is translated, but no remote Git synchronization is performed in this revision.

## Retained limitations

The construction and accepted-instance error claims remain subject to their original mathematical and implementation assumptions. External peer review, formalization of all-size proofs, historical priority, Clifford+T resource optimality, and hardware advantage are not established by this edition.
