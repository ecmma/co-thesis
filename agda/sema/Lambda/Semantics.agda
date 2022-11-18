------------------------------------------------------------------------
-- Functional semantics for the λ-calculus with constants
------------------------------------------------------------------------

module Lambda.Semantics where 

open import Size
open import Lambda.Syntax
open import Data.Nat using (suc)
open import Data.Maybe using (Maybe)
open import Codata.Sized.Delay using (Delay)
open import Codata.Sized.Thunk using (Thunk)
open import Codata.Sized.Partial using (fail)  renaming (bind to _>>=_)
--- 

open Delay
open Thunk
open Maybe 
---

mutual

  eval : ∀ { i n } -> Tm n -> Env n -> Delay (Maybe Value) i
  eval (con i) ρ = now (just (con i))
  eval (var x) ρ = now (just (lookup ρ x))
  eval (ƛ t) ρ =  now (just (ƛᵥ t ρ))
  eval (t ∙ u) ρ = eval t ρ >>= λ f -> eval u ρ >>= λ v -> apply f v

  apply : ∀ {i} -> Value -> Value -> Delay (Maybe Value) i
  apply (con i) v = fail 
  apply (ƛᵥ t ρ) v = later (beta t ρ v)
  
  beta : ∀ {i n} -> Tm (suc n) -> Env n -> Value -> Thunk (Delay (Maybe Value)) i
  force(beta t ρ v)  = eval t (v , ρ)


------------------------------------------------------------------------
-- Examples
module _ where 
 open import Codata.Sized.Partial using (never)
 open import Codata.Sized.Partial.Bisimilarity.Weak

 -- Ω is weakly bisimilar to never.
 Ω-loops : ∀ {i} -> i ⊢ (eval Ω ε) ≈ never
 Ω-loops = later (λ where .force -> Ω-loops) 
