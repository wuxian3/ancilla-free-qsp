import Mathlib.Analysis.Normed.Ring.Basic
import Mathlib.Tactic.NoncommRing
import Mathlib.Tactic.Linarith

/-! Noncommutative norm estimates underlying `eq:telescoping` and
`prop:compileerror`. Specialize the normed ring to continuous linear operators;
the multiplication order is algebraic (the rightmost factor executes first). -/

namespace QSP

variable {A : Type*} [NormedRing A] [NormOneClass A]

theorem contraction_product (xs : List A) (h : ∀ x ∈ xs, ‖x‖ ≤ 1) :
    ‖xs.prod‖ ≤ 1 := by
  induction xs with
  | nil => simp
  | cons x xs ih =>
    simp only [List.prod_cons]
    calc
      ‖x * xs.prod‖ ≤ ‖x‖ * ‖xs.prod‖ := norm_mul_le _ _
      _ ≤ 1 * 1 := mul_le_mul (h x (by simp))
        (ih (fun y hy => h y (by simp [hy]))) (norm_nonneg _) zero_le_one
      _ = 1 := one_mul _

/-- The error sum includes every list entry, including repeated executions. -/
theorem product_error (xs : List (A × A))
    (h : ∀ x ∈ xs, ‖x.1‖ ≤ 1 ∧ ‖x.2‖ ≤ 1) :
    ‖(xs.map Prod.fst).prod - (xs.map Prod.snd).prod‖ ≤
      (xs.map (fun x => ‖x.1 - x.2‖)).sum := by
  induction xs with
  | nil => simp
  | cons x xs ih =>
    have hx := h x (by simp)
    have ht : ∀ y ∈ xs, ‖y.1‖ ≤ 1 ∧ ‖y.2‖ ≤ 1 :=
      fun y hy => h y (by simp [hy])
    have hp : ‖(xs.map Prod.fst).prod‖ ≤ 1 := by
      apply contraction_product
      intro y hy
      obtain ⟨z, hz, rfl⟩ := List.mem_map.mp hy
      exact (ht z hz).1
    simp only [List.map_cons, List.prod_cons, List.sum_cons]
    calc
      ‖x.1 * (xs.map Prod.fst).prod - x.2 * (xs.map Prod.snd).prod‖ =
          ‖(x.1 - x.2) * (xs.map Prod.fst).prod +
            x.2 * ((xs.map Prod.fst).prod - (xs.map Prod.snd).prod)‖ := by
              congr 1; noncomm_ring
      _ ≤ ‖(x.1 - x.2) * (xs.map Prod.fst).prod‖ +
          ‖x.2 * ((xs.map Prod.fst).prod - (xs.map Prod.snd).prod)‖ := norm_add_le _ _
      _ ≤ ‖x.1 - x.2‖ * ‖(xs.map Prod.fst).prod‖ +
          ‖x.2‖ * ‖(xs.map Prod.fst).prod - (xs.map Prod.snd).prod‖ :=
            add_le_add (norm_mul_le _ _) (norm_mul_le _ _)
      _ ≤ ‖x.1 - x.2‖ + (xs.map (fun y => ‖y.1 - y.2‖)).sum :=
        add_le_add (mul_le_of_le_one_right (norm_nonneg _) hp)
          ((mul_le_of_le_one_left (norm_nonneg _) hx.2).trans (ih ht))

omit [NormOneClass A] in
/-- Exact inverse pairing transfers a forward error bound to the inverse. -/
theorem inverse_error (u ui v vi : A) (hu : ui * u = 1) (hv : v * vi = 1)
    (hui : ‖ui‖ ≤ 1) (hvi : ‖vi‖ ≤ 1) : ‖ui - vi‖ ≤ ‖u - v‖ := by
  have hid : ui - vi = ui * (v - u) * vi := by
    rw [mul_sub, sub_mul, mul_assoc ui v vi, hv, mul_one, hu, one_mul]
  rw [hid]
  calc
    ‖ui * (v - u) * vi‖ ≤ ‖ui * (v - u)‖ * ‖vi‖ := norm_mul_le _ _
    _ ≤ ‖ui * (v - u)‖ := mul_le_of_le_one_right (norm_nonneg _) hvi
    _ ≤ ‖ui‖ * ‖v - u‖ := norm_mul_le _ _
    _ ≤ ‖v - u‖ := mul_le_of_le_one_left (norm_nonneg _) hui
    _ = ‖u - v‖ := norm_sub_rev _ _

/-- A reflection block with exactly paired inverses costs at most 2 eta + rho. -/
theorem conjugation_error (u ui v vi r s : A) (eta rho : ℝ)
    (hu : ui * u = 1) (hv : v * vi = 1)
    (huc : ‖u‖ ≤ 1) (huic : ‖ui‖ ≤ 1) (hvc : ‖v‖ ≤ 1) (hvic : ‖vi‖ ≤ 1)
    (hrc : ‖r‖ ≤ 1) (hsc : ‖s‖ ≤ 1)
    (he : ‖u - v‖ ≤ eta) (hr : ‖r - s‖ ≤ rho) :
    ‖u * r * ui - v * s * vi‖ ≤ 2 * eta + rho := by
  have h := product_error [(u, v), (r, s), (ui, vi)] (by
    intro x hx
    simp only [List.mem_cons, List.not_mem_nil, or_false] at hx
    rcases hx with rfl | rfl | rfl
    · exact ⟨huc, hvc⟩
    · exact ⟨hrc, hsc⟩
    · exact ⟨huic, hvic⟩)
  simp only [List.map_cons, List.map_nil, List.prod_cons, List.prod_nil,
    List.sum_cons, List.sum_nil, mul_one, add_zero] at h
  have hi := (inverse_error u ui v vi hu hv huic hvic).trans he
  simp only [mul_assoc]
  linarith

end QSP
