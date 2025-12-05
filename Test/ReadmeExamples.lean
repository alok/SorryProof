import SorryProof

/-! Test that all README examples actually compile -/

-- README Example 1: simple proof deferral with sorry_proof
def increment (n : Nat) : { m : Nat // m > n } :=
  ⟨n + 1, sorry_proof⟩

#eval! increment 5  -- Works! Outputs 6

-- README Example 2: AppConfig with sorry_data
structure AppConfig where
  database : sorry_data   -- Will define DatabaseConfig later

-- README Example 3: myFunc with sorry_proof
def myFunc (n : Nat) : { m : Nat // m > 0 } :=
  ⟨n + 1, sorry_proof⟩  -- sorry_proof only works for Prop

#eval! myFunc 10  -- Should output 11
