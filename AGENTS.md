# Project instructions

- This repository contains a frozen research manuscript and a partial formalization.
- Main TeX entry: `paper/qsp_paper.tex`; compiler: pdfLaTeX plus Biber.
- Lean toolchain and dependency revisions are pinned. Do not silently upgrade them.
- Verify changes with `lake build`, `python scripts/check_axioms.py` and
  `python scripts/check_repository.py`, as relevant to the changes.
- Every new proof module must be imported by `QSP.lean`. All project theorems use
  namespace `QSP` and ordinary `theorem` declarations so the axiom audit includes them.
- No proof holes, custom axioms or native evaluation shortcuts in theorem proofs.
  Preserve the distinction between a proved conclusion and a hypothesis.
- Update `docs/formalization.md` when proof coverage or assumptions change.
- Do not describe the main complexity theorem, interval kernel, circuit compiler,
  trace-distance corollary or lost certificates as verified by the existing library.
- Imported files are hashed in `docs/import-manifest.json`. Keep the original
  snapshot unchanged unless the user specifically requests manuscript revision.
- Historical editorial records are not current validation results. Do not fabricate
  missing research archives, authors, experiments or successful CI runs.
- Publishing to GitHub or pushing to Overleaf requires authorization for that action.
- Repository skills may live in `skills/` if a future task needs them. No skills are
  installed into a user's profile by this repository.
