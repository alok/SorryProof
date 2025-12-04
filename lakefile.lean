import Lake
open Lake DSL

package sorryproof where
  -- Enable Verso documentation (commented out for now due to strict parsing)
  -- leanOptions := #[⟨`doc.verso, true⟩]

@[default_target]
lean_lib SorryProof where
  roots := #[`SorryProof]

lean_lib Test where
  globs := #[.submodules `Test]
