# 无辅助量子比特的稀疏量子态制备

本仓库整理了 Overleaf 论文源码、历史实验摘要与新增的 Lean 4 证明。
论文仍是研究草稿，**完整的渐近复杂度主定理尚未形式化**。

新增证明覆盖除子封闭单项式族的基数约束、计算批次的空间约束、脏工作位回声消除、
复内积空间中的 Householder 反射、逐次执行的算子误差累积、精确逆操作配对、
以及从源电路误差到目标态验收的推导。具体假设及尚未证明的环节见
[形式化对应表](docs/formalization.md)。

安装 Lean/elan 和 Python 后，在仓库根目录运行：

```sh
lake exe cache get
lake build
python scripts/check_axioms.py
python scripts/check_repository.py
```

论文入口为 `paper/qsp_paper.tex`，使用 pdfLaTeX + Biber。
原始研究归档 `QSP-CYCLE13-REVIEW.zip` 已缺失，因此现有数据只能支持表格再生成，
不能支持原始电路实验或证书重放。仓库不会将摘要一致性检查表述为完整复现。

本地整理不会自动同步回 Overleaf。源码采用 Apache-2.0；原论文作者信息仍待作者填写。
