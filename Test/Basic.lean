import SorryProof

-- Test that sorry_proof works for proofs and keeps code computable
def testProof (n : Nat) : { m : Nat // m ≥ n } :=
  ⟨n + 1, sorry_proof⟩

-- Verify it's computable (use #eval! since it involves axioms)
#eval! testProof 5  -- Should output ⟨6, _⟩

-- Test sorry_proof as a tactic
theorem testTheorem : ∀ n : Nat, n + 0 = n := by
  intro n
  sorry_proof

-- Test that sorry_data works for types (in field position)
structure TestConfig where
  value : Nat
  complexField : sorry_data  -- Placeholder for some complex type

-- Verify sorry_proof only accepts Prop (this should fail to typecheck)
-- Uncomment to verify:
-- def shouldFail : Nat := sorry_proof  -- Error: type mismatch

-- Verify sorry_data only accepts Type (this should fail for Prop)
-- Uncomment to verify:
-- theorem shouldFail2 : True := sorry_data  -- Error: type mismatch
