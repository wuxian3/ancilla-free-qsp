"""Ask Lean for the transitive axioms of every theorem in the QSP namespace."""
from pathlib import Path
import json
import re
import subprocess

ROOT = Path(__file__).resolve().parents[1]
ALLOWED = {"propext", "Classical.choice", "Quot.sound"}


def main():
    names = []
    for source in sorted((ROOT / "QSP").glob("*.lean")):
        names.extend("QSP." + name for name in re.findall(
            r"^theorem\s+(\w+)", source.read_text(encoding="utf-8"), re.MULTILINE))
    if not names or len(names) != len(set(names)):
        raise SystemExit("No theorems found, or duplicate theorem names.")
    build = ROOT / "build"
    build.mkdir(exist_ok=True)
    audit = build / "AxiomAudit.lean"
    audit.write_text("import QSP\n\n" + "\n".join(
        "#print axioms " + name for name in names) + "\n", encoding="utf-8")
    result = subprocess.run(["lake", "env", "lean", str(audit)], cwd=ROOT,
                            capture_output=True, text=True, encoding="utf-8")
    if result.returncode:
        raise SystemExit(result.stdout + result.stderr)
    found = {}
    for name, axioms in re.findall(
            r"'([^']+)' depends on axioms:\s*\[([^\]]*)\]", result.stdout):
        found[name] = sorted(x.strip() for x in axioms.split(",") if x.strip())
    for name in re.findall(r"'([^']+)' does not depend on any axioms", result.stdout):
        found[name] = []
    if set(found) != set(names):
        raise SystemExit("Incomplete axiom audit:\n" + result.stdout + result.stderr)
    for name, axioms in found.items():
        unexpected = set(axioms) - ALLOWED
        if unexpected:
            raise SystemExit(f"Rejected axioms in {name}: {sorted(unexpected)}")
    report = {"allowed_axioms": sorted(ALLOWED), "theorems": found}
    (build / "axioms.json").write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(f"PASS: {len(found)} theorem axiom closures; no proof holes or custom axioms.")


if __name__ == "__main__":
    main()
