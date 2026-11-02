"""Regenerate paper tables from frozen JSON summaries. Standard library only."""
from pathlib import Path
from decimal import Decimal, ROUND_CEILING
import json
ROOT=Path(__file__).resolve().parent

def integer(value):
    return f"{value:,}".replace(",", r"\,")

def sci_up(value, digits=4):
    x=Decimal(str(value))
    if x==0: return "$0$"
    exponent=x.adjusted()
    mantissa=x.scaleb(-exponent).quantize(Decimal(1).scaleb(1-digits),rounding=ROUND_CEILING)
    return f"${mantissa}\\times10^{{{exponent}}}$"

def main():
    exact=json.loads((ROOT/'evidence/exact_reflection_results.json').read_text())
    selected=[(8,16),(10,100),(12,144),(16,32)]
    rows=[]
    for n,d in selected:
        r=next(r for r in exact['finite_resources'] if (r['n'],r['d'])==(n,d))
        assert r['dense'] is True
        rows.append(f"$({n},{d})$ & "+" & ".join(integer(r[k]) for k in ['old_depth','new_depth','old_gates','new_gates'])+r" \\")
    text=r"""\begin{table}[tb]
\centering\small
\caption{Exact resource comparison with identical targets, batches, and local cores; only the zero-state reflection is replaced. Every row received a complete state-vector check.}\label{tab:exactresources}
\begin{tabular}{@{}rrrrr@{}}
\toprule
$(n,d)$ & Old depth & New depth & Old gates & New gates\\
\midrule
"""+'\n'.join(rows)+r"""
\bottomrule
\end{tabular}
\end{table}
"""
    (ROOT/'tables/exact_resources.tex').write_text(text,encoding='utf-8')
    target=json.loads((ROOT/'evidence/target_error_results.json').read_text())
    rows=[]
    for r in target['historical_rows']:
        assert r['target_error_upper'] < r['requested_total'] == 0.01
        obs=f"{r['measured_dense_l2']:.6g}"
        total=Decimal(str(r['target_error_upper'])).quantize(Decimal('0.000000001'),rounding=ROUND_CEILING)
        rows.append(f"$({r['n']},{r['d']})$ & {sci_up(r['data_error_upper'])} & ${total}$ & ${obs}$ & {integer(r['depth'])} & {integer(r['gates'])}"+r" \\")
    text=r"""\begin{table}[tb]
\centering\small\setlength{\tabcolsep}{4pt}
\caption{Target-error certification at total budget $0.01$. The bounds $B$ and $B+E_{\rm compile}$ are rounded upward; observed errors are diagnostic only.}\label{tab:errorresources}
\begin{tabular}{@{}rrrrrr@{}}
\toprule
$(n,d)$ & $B$ & $B+E_{\rm compile}$ & Observed error & Depth & Gates\\
\midrule
"""+'\n'.join(rows)+r"""
\bottomrule
\end{tabular}
\end{table}
"""
    (ROOT/'tables/target_errors.tex').write_text(text,encoding='utf-8')
    print('Regenerated both tables from frozen input summaries.')

if __name__=='__main__': main()
