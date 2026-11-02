import Mathlib.Algebra.Module.Equiv.Basic
import Mathlib.Data.ZMod.Basic
import Mathlib.Algebra.CharP.Two
import Mathlib.Data.Finsupp.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.Tactic.LinearCombination

/-! The six chronological stages in `lem:echo`, on arbitrary binary registers.
The CNOT synthesis claim establishing the block form is a separate obligation. -/

namespace QSP

abbrev Bits (n : ℕ) := Fin n → ZMod 2

variable {s t w : ℕ}

/-- Registers are ordered as source, target, workspace. -/
abbrev Registers (s t w : ℕ) := Bits s × Bits t × Bits w

def compute (R : Bits w ≃ₗ[ZMod 2] Bits w) (P : Bits s →ₗ[ZMod 2] Bits w)
    (r : Registers s t w) : Registers s t w :=
  (r.1, r.2.1, R r.2.2 + P r.1)

def uncompute (R : Bits w ≃ₗ[ZMod 2] Bits w) (P : Bits s →ₗ[ZMod 2] Bits w)
    (r : Registers s t w) : Registers s t w :=
  (r.1, r.2.1, R.symm (r.2.2 - P r.1))

def writeTarget (A : Bits w →ₗ[ZMod 2] Bits t)
    (r : Registers s t w) : Registers s t w :=
  (r.1, r.2.1 + A r.2.2, r.2.2)

def dirtyOnly (R : Bits w ≃ₗ[ZMod 2] Bits w)
    (r : Registers s t w) : Registers s t w :=
  (r.1, r.2.1, R r.2.2)

def undoDirtyOnly (R : Bits w ≃ₗ[ZMod 2] Bits w)
    (r : Registers s t w) : Registers s t w :=
  (r.1, r.2.1, R.symm r.2.2)

def echo (R : Bits w ≃ₗ[ZMod 2] Bits w) (P : Bits s →ₗ[ZMod 2] Bits w)
    (A : Bits w →ₗ[ZMod 2] Bits t) (r : Registers s t w) : Registers s t w :=
  undoDirtyOnly R (writeTarget A (dirtyOnly R
    (uncompute R P (writeTarget A (compute R P r)))))

theorem compute_inverse (R : Bits w ≃ₗ[ZMod 2] Bits w)
    (P : Bits s →ₗ[ZMod 2] Bits w) (r : Registers s t w) :
    uncompute R P (compute R P r) = r := by
  rcases r with ⟨y, t, w⟩
  simp [uncompute, compute]

/-- The source and arbitrary dirty workspace are restored exactly. -/
theorem dirty_workspace_echo (R : Bits w ≃ₗ[ZMod 2] Bits w)
    (P : Bits s →ₗ[ZMod 2] Bits w) (A : Bits w →ₗ[ZMod 2] Bits t)
    (y : Bits s) (target : Bits t) (workspace : Bits w) :
    echo R P A (y, target, workspace) = (y, target + A (P y), workspace) := by
  simp only [echo, compute, writeTarget, uncompute, dirtyOnly, undoDirtyOnly,
    add_sub_cancel_right, LinearEquiv.symm_apply_apply, map_add]
  congr 1
  apply Prod.ext
  · ext i
    have hi := CharTwo.add_self_eq_zero ((A (R workspace)) i)
    simp only [Pi.add_apply]
    linear_combination hi
  · rfl

/-- The same equality after linear extension to arbitrary complex amplitudes,
including an untouched reference register. No separability premise is imposed. -/
theorem dirty_workspace_reference {Reference : Type*}
    (R : Bits w ≃ₗ[ZMod 2] Bits w) (P : Bits s →ₗ[ZMod 2] Bits w)
    (A : Bits w →ₗ[ZMod 2] Bits t)
    (state : (Reference × Registers s t w) →₀ ℂ) :
    state.mapDomain (fun z => (z.1, echo R P A z.2)) =
      state.mapDomain (fun z =>
        (z.1, (z.2.1, z.2.2.1 + A (P z.2.1), z.2.2.2))) := by
  apply Finsupp.mapDomain_congr
  intro z _
  rcases z with ⟨reference, y, target, workspace⟩
  simp only [dirty_workspace_echo]

end QSP
