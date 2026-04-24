---
name: grill-me
description: Interview the user relentlessly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. Use when user wants to stress-test a plan, get grilled on their design, or mentions "grill me".
---

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time.

If a question can be answered by exploring the codebase, explore the codebase instead.

## During the session

**Sharpen fuzzy language.** When the user uses vague or overloaded terms, propose a precise canonical term. "You're saying 'account' — do you mean the Customer or the User? Those are different things."

**State the stakes.** For each question, say what breaks or degrades if the answer is wrong — this forces the user to weigh the decision properly rather than hand-wave.

**Stress-test with concrete scenarios.** When relationships or boundaries are discussed, invent specific scenarios that probe edge cases and force the user to be precise. Don't accept hand-waving — make them commit to how it works in the hard cases.

**Cross-reference with code.** When the user states how something works, check whether the code agrees. If you find a contradiction, surface it: "Your code does X, but you just said Y — which is right?"
