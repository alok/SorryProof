# SorryProof

Type-safe placeholders for Lean 4 that don't block code generation.

## Installation

Add to your `lakefile.lean`:

```lean
require sorryproof from git "https://github.com/alok/SorryProof" @ "main"
```

## Usage

```lean
import SorryProof

-- sorry_proof only fills Prop holes - code still compiles!
def factorial (n : Nat) : { m : Nat // m > 0 } :=
  ⟨if n = 0 then 1 else n * (factorial (n-1)).val, sorry_proof⟩

#eval factorial 5  -- Works! Outputs ⟨120, _⟩

-- sorry_data stubs out types during development
structure AppConfig where
  database : sorry_data   -- Will define DatabaseConfig later
```

## Why?

Lean's built-in `sorry` has type `∀ {α : Sort u}, α` - it fills *any* hole. This blocks code generation even when used in proof positions:

```lean
-- This doesn't compile to executable code!
def myFunc (n : Nat) : { m : Nat // m > 0 } :=
  ⟨n + 1, sorry⟩  -- sorry blocks codegen
```

`sorry_proof` is restricted to `Prop`, so proofs get erased at runtime and your code compiles:

```lean
-- This compiles and runs!
def myFunc (n : Nat) : { m : Nat // m > 0 } :=
  ⟨n + 1, sorry_proof⟩  -- sorry_proof only works for Prop
```

## API

| Macro | Type | Use Case |
|-------|------|----------|
| `sorry_proof` | `∀ P : Prop, P` | Defer proofs, keep code computable |
| `sorry_data` | `∀ α : Type _, α` | Stub out data types (crashes if evaluated) |

Both work as terms and tactics.

## Philosophy

Technical debt is acceptable during development. These macros make intent explicit:
- `sorry_proof`: "I owe a proof here, but the code runs"
- `sorry_data`: "I owe a type definition here"

Designed for scientific computing where working code matters more than complete verification.

## License

Apache 2.0
