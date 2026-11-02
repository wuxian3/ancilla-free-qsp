"""Check manuscript provenance, evidence hashes, table reproduction and proof hygiene.

These checks do not replay the missing historical circuit certificates.
"""
from pathlib import Path
import hashlib
import json
import re
import runpy
import shutil
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def lean_code(text):
    """Remove nested Lean block comments and line comments for a source hygiene check."""
    out, i, depth = [], 0, 0
    while i < len(text):
        pair = text[i:i + 2]
        if pair == "/-":
            depth += 1
            i += 2
        elif depth and pair == "-/":
            depth -= 1
            i += 2
        elif not depth and pair == "--":
            end = text.find("\n", i)
            i = len(text) if end < 0 else end
        else:
            if not depth:
                out.append(text[i])
            i += 1
    if depth:
        raise ValueError("Unclosed Lean comment")
    return "".join(out)


def main():
    manifest = json.loads((ROOT / "docs/import-manifest.json").read_text(encoding="utf-8"))
    for record in manifest["files"]:
        path = ROOT / record["path"]
        if sha256(path) != record["sha256"]:
            raise SystemExit(f"Imported manuscript changed: {record['path']}")
    print(f"PASS: {len(manifest['files'])} imported files match the Overleaf snapshot.")
    paper = ROOT / "paper"
    source_map = json.loads((paper / "qsp_paper/evidence/SOURCE_MAP.json").read_text())
    for record in source_map:
        if sha256(paper / record["paper_copy"]) != record["sha256"]:
            raise SystemExit(f"Evidence hash mismatch: {record['paper_copy']}")
    print("PASS: all three frozen evidence summaries match their recorded hashes.")
    # Work in an isolated copy; checking must not silently repair stale tables.
    (ROOT / "build").mkdir(exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="tables-", dir=ROOT / "build") as temporary:
        target = Path(temporary) / "qsp_paper"
        shutil.copytree(paper / "qsp_paper", target)
        runpy.run_path(str(target / "generate_tables.py"), run_name="__main__")
        for name in ("exact_resources.tex", "target_errors.tex"):
            # Git may normalize source line endings on checkout.
            expected = (paper / "qsp_paper/tables" / name).read_text(encoding="utf-8")
            observed = (target / "tables" / name).read_text(encoding="utf-8")
            if expected != observed:
                raise SystemExit(f"Generated table differs: {name}")
    print("PASS: both tables reproduce from the historical summaries.")
    files = [ROOT / "QSP.lean", *sorted((ROOT / "QSP").glob("*.lean"))]
    for path in files:
        code = lean_code(path.read_text(encoding="utf-8"))
        if re.search(r"\b(sorry|admit|axiom|unsafe|native_decide)\b", code):
            raise SystemExit(f"Forbidden proof escape in {path.relative_to(ROOT)}")
    imports = set(re.findall(r"^import (QSP\.\w+)$", files[0].read_text(), re.MULTILINE))
    required = {"QSP." + p.stem for p in files[1:]}
    if imports != required:
        raise SystemExit(f"Root module imports do not cover the library: {required ^ imports}")
    print("PASS: every proof module is imported; no explicit proof escapes.")


if __name__ == "__main__":
    main()
