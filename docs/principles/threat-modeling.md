# Threat Modeling

**Principle:** Every system has actors with misaligned incentives. Enumerate them at design time — who they are, what they want, what damage they can do, and what assumptions guard against them. Build the assumptions into the design, not the documentation.

**Why:** "secure" is a property of a design relative to a threat model; without an explicit model, "is this secure?" has no answer.

## When It Applies

- Any code that crosses a trust boundary (user input, network, external contract calls, third-party APIs)
- Authorization decisions of any kind
- State that an adversary can influence (storage, queues, files, parameters)
- Operations that are expensive, irreversible, or visible to others

A change in any of these is "security-sensitive" in the sense [never block on the human](./never-block-on-the-human.md) escalates on. Pure computation with no external input, and internal helpers called only by trusted code in the same trust domain, need no threat model.

## Pattern

1. **List the actors,** malicious ones included: end-users, peers, ops, attackers, supply chain, future-you. For each, ask what they want and what capabilities they have.
2. **Identify trust boundaries,** where data crosses from "I control this" to "I don't," and validate at the crossing.
3. **Enumerate threats with STRIDE:** Spoofing, Tampering, Repudiation, Information disclosure, DoS, Elevation of privilege.
4. **Make assumptions explicit, then defend them.** "We assume the caller has authenticated" is fine *if* you check it. "We assume no one will call this twice" is not.

## Heuristics

- **Least privilege, fail-safe defaults, complete mediation:** minimum capability per actor; when in doubt, deny; every access to a protected resource is checked, with no fast paths around the check.
- **Don't roll your own crypto.** Use audited primitives.
- **Revisit the model when the attack surface changes.**
