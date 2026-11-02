import Mathlib.Data.Finset.Powerset
import Lean.Elab.Tactic.Omega

/-! Combinatorial consequences of the hypotheses in `lem:monomial` and
`lem:recycling`. This file does not assert existence of the evaluation basis. -/

namespace QSP

variable {ι : Type*}

/-- A squarefree monomial is represented by its finite set of variables. -/
def DivisorClosed (B : Finset (Finset ι)) : Prop :=
  ∀ s ∈ B, ∀ t ⊆ s, t ∈ B

/-- Every divisor of a retained squarefree monomial is retained. -/
theorem powerset_subset_basis {B : Finset (Finset ι)} (hB : DivisorClosed B)
    {s : Finset ι} (hs : s ∈ B) : s.powerset ⊆ B := by
  intro t ht
  exact hB s hs t (Finset.mem_powerset.mp ht)

/-- The exact cardinal inequality underlying the logarithmic degree bound. -/
theorem monomial_degree_bound {B : Finset (Finset ι)} (hB : DivisorClosed B)
    {s : Finset ι} (hs : s ∈ B) : 2 ^ s.card ≤ B.card := by
  calc
    2 ^ s.card = s.powerset.card := (Finset.card_powerset s).symm
    _ ≤ B.card := Finset.card_le_card (powerset_subset_basis hB hs)

/-- A full feature batch consumes at least a fifth of the remaining locations. -/
theorem full_batch_progress (z : ℕ) (hz : 3 ≤ z) : z ≤ 5 * (z / 3) := by
  omega

/-- The private controls and result locations fit in the available zero wires. -/
theorem batch_workspace_fits (z q : ℕ) : 3 * min q (z / 3) ≤ z := by
  have h := Nat.min_le_right q (z / 3)
  omega

/-- A batch which is smaller than the capacity exhausts the ready products. -/
theorem nonfull_batch_exhausts (z q : ℕ) (h : min q (z / 3) < z / 3) :
    min q (z / 3) = q := by
  omega

end QSP
