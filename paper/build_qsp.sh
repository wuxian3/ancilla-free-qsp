#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
# Tables are already included. Python is needed only to regenerate them.
if [[ "${1:-}" == "--regenerate-tables" ]]; then
    python3 qsp_paper/generate_tables.py
fi
for command in pdflatex biber; do
    if ! command -v "$command" >/dev/null 2>&1; then
        printf 'Required command not found: %s\n' "$command" >&2
        exit 1
    fi
done
pdflatex -interaction=nonstopmode -halt-on-error -file-line-error qsp_paper.tex
biber qsp_paper
pdflatex -interaction=nonstopmode -halt-on-error -file-line-error qsp_paper.tex
pdflatex -interaction=nonstopmode -halt-on-error -file-line-error qsp_paper.tex
