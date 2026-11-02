# Paper-to-Lean proof map

This is a **partial formalization of supporting results**, not a formal proof of
Theorem 2.1. Paper labels below refer to the unchanged imported manuscript.
Every listed theorem is universally quantified, with its assumptions visible in
Lean. No numerical sample is used as a substitute for a universal proof.

## Covered statements

| Paper location | Lean declarations in namespace `QSP` | Exact scope |
| --- | --- | --- |
| Lemma 3.2, `lem:monomial` | `powerset_subset_basis`, `monomial_degree_bound` | A finite divisor-closed family containing a squarefree monomial of degree `t` has at least `2^t` members. Divisor closure is a hypothesis; basis existence is not assumed as an axiom or proved here. |
| Lemma 3.3, `lem:recycling` | `full_batch_progress`, `batch_workspace_fits`, `nonfull_batch_exhausts` | The exact integer inequalities for `floor(z/3)` batches, including the small-integer boundary. No full scheduler or asymptotic batch-count proof is claimed. |
| Lemma 4.3, `lem:echo` | `compute_inverse`, `dirty_workspace_echo`, `dirty_workspace_reference` | The six chronological stages give `(y,t,w) -> (y,t+APy,w)` for arbitrary binary registers, given an invertible linear `R` and linear `P,A`. Linear extension to complex amplitudes includes an arbitrary untouched reference; no zero-workspace or separability premise. |
| Lemma 5.1, `lem:householder` | `reflection_conjugation`, `reflection_phase_invariant`, `prepared_reflection` | The full-space conjugation identity for a complex linear isometric equivalence, including preparation up to a unit-modulus scalar. The extension away from the input vector is unrestricted. |
| Lemma 5.1 and the reflection step in Lemma 5.2 | `reflection_fixes_orthogonal`, `reflection_negates_axis`, `reflection_involutive` | Orthogonal vectors are fixed; a normalized axis is negated; normalized reflections square to the identity. |
| Equation (7.3), `eq:telescoping` | `contraction_product`, `product_error` | Products of contractions satisfy the sum-of-errors bound in an arbitrary normed ring. The list retains repeated execution occurrences. Specialize to the spectral norm on continuous linear operators. |
| Proposition 7.2, `prop:compileerror` | `inverse_error`, `conjugation_error` | Exact inverse identities and contraction bounds imply the inverse error bound and the `2 eta + rho` conjugation-block bound. |
| Equation (7.6), `eq:compilebound` | `compilation_ledger` | Per-occurrence block bounds sum to `initError + 2 * sum eta + q * rho`. Indices must represent executions, not unique stored routines. |
| Theorem 7.3, `thm:certification` | `target_error_bound`, `accepted_target_error` | A source residual bound plus a full operator-norm compilation bound implies the phase-sensitive vector error bound and its acceptance consequence. |

## Meaning of the formal objects

- `Bits n = Fin n -> ZMod 2`: actual binary register values, with no arbitrary
  characteristic-two ring supplied as an extra axiom.
- `R` is a linear equivalence, while `P` and `A` are linear maps. The six stages
  are explicit functions, not a single function defined to equal the desired result.
- `reflection v x = x - (2 * inner v x) • v` is an operator acting on the whole
  complex inner-product space. Normalization is explicit where it is required.
- `E ≃ₗᵢ[ℂ] E` describes a surjective complex linear isometry, hence the finite
  dimensional unitary case. Its inverse is the adjoint in this setting.
- The normed-ring product follows algebraic multiplication order: the rightmost
  operator executes first. Bounds are independent of this naming convention.
- The final acceptance theorem uses `E →L[ℂ] E`, so the operator bound covers
  leakage outside the source support. It is not merely a bound on one output.

## Explicit remaining obligations

1. **Theorem 2.1:** all-size gate/depth existence, uniform asymptotic constants,
   the fixed-polynomial-window lower bounds, and the imported synthesis theorems.
2. **Geometry and feature construction:** affine support projection, existence
   and greedy construction of the divisor-closed evaluation basis, NCT circuit
   synthesis, dependency levels, and the total schedule bound.
3. **Reconstruction:** deriving `(R,P)` from an arbitrary CNOT sequence and
   justifying deletion of source-controlled gates from its syntax; rectangular
   invertible decompositions; the two-batch layout and resource accounting.
4. **Batched preparation:** the complex pivot normalization/elimination formula,
   partition coverage, the weighted-W circuit, and gate-level unitary semantics.
5. **Lemma 7.1:** the exact spectral-norm identity
   `2 sqrt(1 - |<v,w>|^2)` and its phase-optimized vector bound.
6. **Numerical certification:** sine/cosine enclosures, outward interval
   arithmetic, binding a certificate to actual source and compiled sequences,
   rational target normalization and the pure-state trace-distance corollary.
7. **Implementation replay:** the lost research archive, its 13 certificates and
   eight negative controls. Lean proves none of their historical execution claims.

The remaining items are documented as obligations, not encoded as new axioms.
The hypotheses of proved theorems must not be relabeled as proved conclusions.

## Trust and verification

Run `lake build`, then `python scripts/check_axioms.py`. The latter asks Lean for
the transitive axiom dependencies of every project theorem and checks that they
are a subset of `{propext, Classical.choice, Quot.sound}`. This is Lean's usual
classical mathematical foundation; the audit is not an independent reimplementation
of Lean's kernel. Mathlib is pinned to a specific source commit.

`python scripts/check_repository.py` additionally checks source hygiene, that the
root module imports every proof module, and manuscript/data provenance. It does
not replace the kernel check. CI repeats these commands; merely adding a workflow
does not establish that a remote CI run has passed.
