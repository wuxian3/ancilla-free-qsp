import Mathlib.Analysis.Normed.Operator.Basic
import Mathlib.Analysis.Complex.Basic
import Mathlib.Tactic.Linarith

/-! The vector-norm part of `thm:certification`. Interval soundness, circuit
binding, and pure-state trace distance are explicitly outside this file. -/

namespace QSP

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℂ E]

/-- The operator bound controls all output coordinates, including leakage. -/
theorem target_error_bound (source compiled : E →L[ℂ] E) (input target : E)
    (B error : ℝ) (hinput : ‖input‖ = 1)
    (hsource : ‖source input - target‖ ≤ B)
    (hcompile : ‖compiled - source‖ ≤ error) :
    ‖compiled input - target‖ ≤ B + error := by
  have hstep : ‖compiled input - source input‖ ≤ error := by
    calc
      _ = ‖(compiled - source) input‖ := rfl
      _ ≤ ‖compiled - source‖ * ‖input‖ := (compiled - source).le_opNorm input
      _ ≤ error := by simpa [hinput] using hcompile
  calc
    _ ≤ ‖compiled input - source input‖ + ‖source input - target‖ :=
      norm_sub_le_norm_sub_add_norm_sub _ _ _
    _ ≤ error + B := add_le_add hstep hsource
    _ = B + error := add_comm _ _

theorem accepted_target_error (source compiled : E →L[ℂ] E) (input target : E)
    (B error epsilon : ℝ) (hinput : ‖input‖ = 1)
    (hsource : ‖source input - target‖ ≤ B)
    (hcompile : ‖compiled - source‖ ≤ error)
    (haccept : B + error ≤ epsilon) : ‖compiled input - target‖ ≤ epsilon :=
  (target_error_bound source compiled input target B error hinput hsource hcompile).trans haccept

/-- Aggregating per-execution block budgets gives the paper's compilation ledger. -/
theorem compilation_ledger {ι : Type*} (executions : Finset ι)
    (blockError eta : ι → ℝ) (rho initError : ℝ)
    (hblock : ∀ j ∈ executions, blockError j ≤ 2 * eta j + rho) :
    initError + ∑ j ∈ executions, blockError j ≤
      initError + 2 * (∑ j ∈ executions, eta j) + executions.card * rho := by
  have hsum := Finset.sum_le_sum hblock
  simp only [Finset.sum_add_distrib, ← Finset.mul_sum, Finset.sum_const,
    nsmul_eq_mul] at hsum
  linarith

end QSP
