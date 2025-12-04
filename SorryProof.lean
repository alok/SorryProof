/-!
# SorryProof: Type-Safe Placeholders for Lean 4

This library provides type-restricted variants of Lean's built-in sorry
that ensure you don't accidentally block code generation.

## Motivation

In Lean 4, the standard sorry term has type ∀ {α : Sort u}, α. This means it can
fill in any hole - whether you need a proof (Prop), data (Type), or anything else.
This flexibility is dangerous when developing computable code because sorry blocks
code generation even when used in proof positions.

The macros in this library solve this:
- `sorry_proof` only fills Prop holes - proofs that get erased at runtime
- `sorry_data` only fills Type holes - for stubbing out data types

## Philosophy

Technical debt is acceptable during development. These macros make your intent explicit:
- `sorry_proof`: "I owe a proof here, but the code runs"
- `sorry_data`: "I owe a type definition here"

The library is designed for scientific computing and rapid prototyping where getting
working code matters more than complete verification.
-/

/-- Axiom for proof placeholders. This is the underlying axiom used by `sorry_proof`.

**Warning**: Using this axiom makes your development logically inconsistent.
Only use it for work-in-progress code that you intend to complete later.
-/
axiom sorryProofAxiom {P : Prop} : P

/--
A type-safe proof placeholder that only works for Prop terms.

Unlike the standard sorry, `sorry_proof` is restricted to proofs (Prop),
which means it will never block code generation. Proofs are erased at runtime,
so using `sorry_proof` in a proof context still produces executable code.

### When to Use

Use `sorry_proof` when you:
- Want to defer a proof obligation while keeping code computable
- Are iterating on an algorithm and will verify correctness later
- Need a quick prototype without full verification

### Comparison with sorry

| Feature          | sorry       | sorry_proof        |
|------------------|-------------|--------------------|
| Works in proofs  | Yes         | Yes                |
| Works in data    | Yes         | **No**             |
| Blocks codegen   | Yes         | **No**             |
| Type             | ∀ α, α      | ∀ P : Prop, P      |
-/
macro "sorry_proof" : term => `(sorryProofAxiom)

/--
Tactic mode version of `sorry_proof`.

Use this in tactic proofs to discharge goals you want to defer.
-/
macro "sorry_proof" : tactic => `(tactic| exact sorry_proof)


/-- Axiom for data/type placeholders. This is the underlying axiom used by `sorry_data`.

**Warning**: Using this axiom produces terms that will crash at runtime if evaluated.
Only use it for stubbing out types during early development.
-/
axiom sorryDataAxiom {α : Type _} : α

/--
A type placeholder for stubbing out data types during development.

`sorry_data` is the dual of `sorry_proof` - it's restricted to Type _
rather than Prop. Use it when you need to stub out a type that you haven't
defined yet, or when you want to defer a data definition.

### When to Use

Use `sorry_data` when you:
- Are sketching out a type hierarchy and want to defer some definitions
- Need a placeholder type for incremental compilation
- Want to stub out external FFI types before implementing bindings

### Warning

Unlike `sorry_proof`, using `sorry_data` **will crash at runtime** if the
placeholder value is ever evaluated. It's meant for structural scaffolding,
not for values that will actually be used.

### Type Restriction

`sorry_data` only works for Type _, not Prop. This ensures you don't
accidentally use a data placeholder where you meant to use a proof placeholder.
Use `sorry_proof` for proof obligations.
-/
macro "sorry_data" : term => `(sorryDataAxiom)

/--
Tactic mode version of `sorry_data`.

Use this in tactic mode when constructing data terms.
Note: The apply tactic is used instead of exact because `sorry_data`
might need to unify with a goal that's not directly a Type.
-/
macro "sorry_data" : tactic => `(tactic| apply sorry_data)
