import Mathlib.Analysis.InnerProductSpace.LinearMap
import Mathlib.Tactic.Module

/-! Full-space Householder identities (`lem:householder`). Vectors live in a
complex inner-product space, so these are not numerical matrix spot checks. -/

namespace QSP

open scoped ComplexConjugate

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℂ E]

def reflection (v x : E) : E := x - (2 * inner ℂ v x) • v

theorem reflection_fixes_orthogonal (v x : E) (h : inner ℂ v x = 0) :
    reflection v x = x := by
  simp [reflection, h]

theorem reflection_negates_axis (v : E) (hv : inner ℂ v v = 1) :
    reflection v v = -v := by
  simp only [reflection, hv, mul_one]
  module

theorem reflection_involutive (v x : E) (hv : inner ℂ v v = 1) :
    reflection v (reflection v x) = x := by
  simp only [reflection, inner_sub_right, inner_smul_right, hv, mul_one]
  module

/-- A global phase cancels in the rank-one projector. -/
theorem reflection_phase_invariant (a : ℂ) (ha : conj a * a = 1) (v x : E) :
    reflection (a • v) x = reflection v x := by
  simp only [reflection, inner_smul_left, smul_smul]
  have h : (2 * (conj a * inner ℂ v x)) * a = 2 * inner ℂ v x := by
    calc
      _ = 2 * (conj a * a) * inner ℂ v x := by ring
      _ = _ := by rw [ha]; ring
  rw [h]

/-- Conjugation by any unitary extension depends only on the prepared vector. -/
theorem reflection_conjugation (U : E ≃ₗᵢ[ℂ] E) (v x : E) :
    U (reflection v (U.symm x)) = reflection (U v) x := by
  have h : inner ℂ (U v) x = inner ℂ v (U.symm x) := by
    simpa using U.inner_map_map v (U.symm x)
  simp [reflection, h]

/-- The exact identity in `lem:householder`, including a preparation phase. -/
theorem prepared_reflection (U : E ≃ₗᵢ[ℂ] E) (zero v x : E) (a : ℂ)
    (ha : conj a * a = 1) (hprep : U zero = a • v) :
    U (reflection zero (U.symm x)) = reflection v x := by
  rw [reflection_conjugation, hprep, reflection_phase_invariant a ha]

end QSP
