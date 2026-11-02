# Initial validation: 2026-11-02

The local checks below were executed, not inferred from the existence of scripts.
They cover the initial imported manuscript and supporting Lean library.

| Check | Observed result |
| --- | --- |
| `lake build` | Passed; 1,941 dependency/project jobs resolved; all five QSP modules and root module built |
| `python scripts/check_axioms.py` | Passed for 21 theorem dependency closures; only `propext`, `Classical.choice`, `Quot.sound` |
| Imported source integrity | All 27 imported files matched the source Git blobs |
| Historical evidence integrity | All three JSON summaries matched the recorded SHA-256 hashes |
| Table regeneration | Both generated tables matched the supplied tables |
| Proof source hygiene | Every library module imported; no explicit proof escapes |
| Main-manuscript render | Tectonic 0.17.0 with Biber 2.17 produced a 23-page PDF |
| PDF checks | All 23 pages visually inspected in contact sheets; no replacement glyphs, unresolved `??` references or out-of-page text |

The exact Lean theorem axiom lists, source hashes and render metadata are recorded
in [validation.json](validation.json). That file is an execution record, not an
axiom used by the proofs. Future changes should run the commands again as relevant.

The local TeX installation used Tectonic's XeTeX-based engine. The intended
Overleaf/pdfLaTeX + Biber command remains in `paper/build_qsp.sh`; the GitHub
manuscript job tests that path with latexmk. Tectonic reported a fontconfig
configuration message and an invalid-UTF-8 warning from a bundled `algorithm.sty`
comment. Neither appeared as missing or replacement characters in the rendered PDF.

The full complexity theorem, the interval implementation and historical circuit
certificate replay were **not** validated by these checks. See the
[proof map](formalization.md) and [reproduction limits](reproduction.md).

Remote CI status is available from the repository's Actions tab; no remote success
is asserted merely by this local record.
