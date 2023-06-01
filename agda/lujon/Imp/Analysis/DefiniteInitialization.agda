------------------------------------------------------------------------
-- Definite initialization analysis for IMP and its properties
------------------------------------------------------------------------
module Imp.Analysis.DefiniteInitialization where 

open import Data.Bool
open import Imp.Syntax 
open import Data.Maybe 
open import Data.String
open import Imp.Semantics.BigStep.Functional
---

adia : (a : AExp) -> (s : VarsSet) -> Bool 
adia (const n) s = true 
adia (var id) s = s id
adia (plus a a₁) s = (adia a s) ∧ (adia a₁ s)

bdia : (b : BExp) -> (s : VarsSet) -> Bool 
bdia (const b) s = true 
bdia (le a₁ a₂) s =  (adia a₁ s) ∧ (adia a₂ s)
bdia (BExp.not b) s = bdia b s
bdia (and b b₁) s = (bdia b s) ∧ (bdia b₁ s)

private
 cdia-inner : (c : Command) -> (s : VarsSet) -> Maybe VarsSet
 cdia-inner skip s = just ∅ 
 cdia-inner (assign id a) s with (adia a s) 
 ... | false = nothing 
 ... | true = just (id ↦ s)
 cdia-inner (seq c c₁) s = (cdia-inner c s) >>= λ s₁ -> (cdia-inner c s₁) >>= just
 cdia-inner (ifelse b c c₁) s with (bdia b s) 
 ... | false = nothing 
 ... | true = (cdia-inner c s) >>= λ s₁ -> (cdia-inner c s) >>= λ s₂ -> just (s₁ ∩ s₂)
 cdia-inner (while b c) s with (bdia b s) 
 ... | false = nothing 
 ... | true =  cdia-inner c s >>= λ _ -> just s

cdia : (c : Command) -> (s : VarsSet) -> Bool 
cdia c s with (cdia-inner c s)
... | just x = true
... | nothing = false 


data DiaRel : VarsSet -> Command -> VarsSet -> Set where 
 skip : ∀ (s : VarsSet) -> DiaRel s (skip) s
 assign : ∀ a s id (a⊆s : (avars a) ⊆ s) -> DiaRel s (assign id a) (id ↦ s)
 seq : ∀ s s₁ s₂ c c₁ -> DiaRel s c s₁ -> DiaRel s₁ c₁ s₂ -> DiaRel s (seq c c₁) s₂
 if : ∀ b s s₁ s₂ cᶠ cᵗ (b⊆s : (bvars b) ⊆ s) -> 
  (relcᶠ : DiaRel s cᶠ s₁) -> (relcᵗ : DiaRel s cᵗ s₂) -> DiaRel s (ifelse b cᵗ cᶠ) (s₁ ∩ s₂)
 while : ∀ b s s₁ c -> (b⊆s : (bvars b) ⊆ s) -> DiaRel s c s₁ -> DiaRel s (while b c) s₁

--------------------------------------------------
-- Properties of definite initialization analysis 
--------------------------------------------------
module _ where
 
 open import Data.Product
 open import Data.And
 open import Relation.Binary.PropositionalEquality
 
 rel-dia : ∀ s c -> (relc : DiaRel s c (s ∪ (cvars c))) -> (cdia c s ≡ true)
 rel-dia s skip relc = refl
 rel-dia s (assign id a) relc = {! !}
 rel-dia s (seq c c₁) relc = {! !}
 rel-dia s (ifelse b c c₁) relc = {! !}
 rel-dia s (while b c) relc = {! !}

 dia-rel : ∀ s c -> (cdia c s ≡ true) -> DiaRel s c (s ∪ (cvars c))
 dia-rel s skip x = {! !}
 dia-rel s (assign id a) x = {! !}
 dia-rel s (seq c c₁) x = {! !}
 dia-rel s (ifelse b c c₁) x = {! !}
 dia-rel s (while b c) x = {! !}

 cdia-safe : ∀ (t : Store) (s s' : VarsSet) (c : Command) -> 
  (c⊆s : s ⊆ (dom t)) -> (relc : DiaRel s c s') -> ∃ λ t' -> And (ceval c (just t) ≡ just t') (s' ⊆ (dom t'))
 cdia-safe t s s' skip c⊆s relc = {! !}
 cdia-safe t s s' (assign id a) c⊆s relc = {! !}
 cdia-safe t s s' (seq c c₁) c⊆s relc = {! !}
 cdia-safe t s s' (ifelse b c c₁) c⊆s relc = {! !}
 cdia-safe t s s' (while b c) c⊆s relc = {! !}
