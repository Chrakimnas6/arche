# Threat Modeling

**Principle:** Every system has actors with misaligned incentives. Enumerate them at design time — who they are, what they want, what damage they can do, and what assumptions guard against them. Build the assumptions into the design, not the documentation.

## Why

"Secure" is not a property of code; it's a property of the relationship between a design and a specific threat model. Without an explicit threat model, "is this secure?" has no answer. With one, it has many — each enumerable, each testable. Threat modeling shifts security from intuition to bookkeeping.

## When It Applies

- Any code that crosses a trust boundary (user input, network, external contract calls, third-party APIs)
- Authorization decisions of any kind
- State that an adversary can influence (storage, queues, files, parameters)
- Operations that are expensive, irreversible, or visible to others

## When It Doesn't

- Pure computation with no external input
- Internal helpers called only by trusted code in the same trust domain

## The Pattern

1. **List the actors.** Who interacts with this system, including the malicious ones? End-users, peers, ops, attackers, supply chain, future-you.
2. **For each actor, ask: what do they want? What capabilities do they have?** A user wants their data; an attacker wants someone else's; an admin wants to debug; a buggy peer wants to retry.
3. **Identify trust boundaries.** Where does data cross from "I control this" to "I don't"? Validate at the crossing.
4. **Enumerate the threats** using STRIDE as a checklist: Spoofing, Tampering, Repudiation, Information disclosure, DoS, Elevation of privilege.
5. **Make assumptions explicit, then defend them.** "We assume the caller has authenticated" is fine *if* you check it. "We assume no one will call this twice" is not.

## Heuristics

- **Least privilege.** Code and actors get the minimum capability needed to do their job. (Saltzer & Schroeder, 1975.)
- **Fail-safe defaults.** When in doubt, deny. Errors should err toward refusal, not permission.
- **Complete mediation.** Every access to a protected resource is checked. No fast paths around the check.
- **Don't roll your own crypto.** Use audited primitives. Novel cryptographic constructions are how breaches happen.
- **Adversaries get better.** The threat model is dated the day you write it. Revisit when the attack surface changes.

## Relationship to Other Principles

[Boundary discipline](./boundary-discipline.md) governs *where* validation happens; this governs *what* validation is for and *whom* it defends against. Without a threat model, boundary validation is shape-checking, not security.

[Stop on ambiguity](./stop-on-ambiguity.md) requires escalation on security-sensitive changes. This principle defines when "security-sensitive" applies: any change that affects an enumerated threat or trust boundary.

Language-specific applications live in [docs/applications/](../applications/).

## Citations

Saltzer & Schroeder, "The Protection of Information in Computer Systems" (*Proc. IEEE* 63:1278-1308, 1975) — least privilege, fail-safe defaults, complete mediation, separation of privilege, economy of mechanism. Shostack, *Threat Modeling: Designing for Security* (Wiley, 2014) — STRIDE methodology and operational threat modeling. Schneier, *Secrets and Lies* (Wiley, 2000) — "attacks always get better"; security as a continuous discipline.
