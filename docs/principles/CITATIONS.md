# Principle Citations

Sources backing each principle, kept as evidence for the promotion bar in `.github/upstream-monitor.md` (Step 3.5). Agents applying a principle do not need this file.

## [Boundary Discipline](./boundary-discipline.md)

Meyer, *Object-Oriented Software Construction* (1988/1997) — Design by Contract: preconditions checked at the boundary, internals trust the contract. Hunt & Thomas, *The Pragmatic Programmer* (1999) — assertive programming and contracts. Eric Evans, *Domain-Driven Design* (2003) — bounded contexts and anti-corruption layers at integration boundaries. Alexis King, "Parse, don't validate" (2019) — parsing into domain types at the boundary so internal code never re-checks.

## [Build the Lever](./build-the-lever.md)

The codemod/mechanized-refactor tradition: `gofix` (Go team, 2011) and `jscodeshift` (Facebook, 2015) — large-scale changes as rerunnable, reviewable programs. Hunt & Thomas, *The Pragmatic Programmer* (1999) — code generators and "ubiquitous automation." pstack, `principle-build-the-lever` (cursor/plugins) — the reviewer-reruns-the-artifact framing.

## [Encode Lessons in Structure](./encode-lessons-in-structure.md)

Hunt & Thomas, *The Pragmatic Programmer* (1999) — "DRY" extended to process: don't repeat yourself across instructions and reviews when a tool or check can enforce the rule. Fowler, *Refactoring* (2nd ed., 2018) — making the change easy by mechanizing the recurring transformation. Brooks, *The Mythical Man-Month* (1975) — "conceptual integrity" emerges from structures, not instructions.

## [Exhaust the Design Space Before Committing](./exhaust-the-design-space.md)

Ousterhout, *A Philosophy of Software Design* (2nd ed., 2021) — "Design It Twice." Brooks, *The Mythical Man-Month* (1975), chapter 11 "Plan to Throw One Away" — the first system informs the second.

## [Experience First](./experience-first.md)

Norman, *The Design of Everyday Things* (1988, revised 2013) — affordances and signifiers; design centered on the user's mental model. Krug, *Don't Make Me Think* (New Riders, 2000) — usability as the absence of friction at the interface. Hickey, "Simple Made Easy" (Strange Loop, 2011) — predictability and decomplecting. Kernighan & Pike, *The Practice of Programming* (Addison-Wesley, 1999) — interface ergonomics for libraries and tools.

## [Fix Root Causes](./fix-root-causes.md)

Imai, *Kaizen: The Key to Japan's Competitive Success* (McGraw-Hill, 1986) — Toyota's "5 Whys" methodology for tracing causes back to bedrock. Hunt & Thomas, *The Pragmatic Programmer* (1999) — "Programming by Coincidence" anti-pattern; debug deliberately. Agans, *Debugging: The 9 Indispensable Rules* (AMACOM, 2002) — "Understand the system" + "Make it fail" as systematic root-cause discipline.

## [Foundational Thinking](./foundational-thinking.md)

Brooks, *The Mythical Man-Month* (1975) — "Show me your flowcharts and conceal your tables, and I shall continue to be mystified. Show me your tables, and I won't usually need your flowcharts; they'll be obvious." Hickey, "The Value of Values" (JaxConf, 2012) — values over places. Hunt & Thomas, *The Pragmatic Programmer* (1999) — tracer bullets / scaffolding. Hunt & Thomas, *The Pragmatic Programmer* (20th Anniversary Edition, 2019) — Topic 27, "Don't outrun your headlights." Minsky, "Effective ML" (2011) — make illegal states unrepresentable. Evans, *Domain-Driven Design* (2003) — the domain model as the organizing structure.

## [Guard the Context Window](./guard-the-context-window.md)

Agent-era operating principle (consensus-backed, per the promotion bar's authoritative-backing branch): Anthropic, "Effective context engineering for AI agents" (engineering blog, 2025) — context as a finite resource; curation over accumulation. The context-engineering practitioner literature, 2025–2026 (the term's broad adoption across frontier-lab guidance and tooling docs). pstack, `principle-guard-the-context-window` (cursor/plugins) — an independent implementation of the same rule. obra/superpowers, `subagent-driven-development` — a second independent implementation: file handoffs over pasted context, and a durable progress ledger trusted over recollection after compaction.

## [Make Operations Idempotent](./make-operations-idempotent.md)

Fielding, *Architectural Styles and the Design of Network-based Software Architectures* (UC Irvine PhD dissertation, 2000) — idempotency as a REST architectural constraint. Gray & Reuter, *Transaction Processing: Concepts and Techniques* (Morgan Kaufmann, 1992) — recovery semantics. Kleppmann, *Designing Data-Intensive Applications* (O'Reilly, 2017) — idempotency in distributed systems and exactly-once delivery.

## [Module Depth](./module-depth.md)

Ousterhout, *A Philosophy of Software Design* (2nd ed., 2021) — the source of "deep modules" and the depth/shallow framing. Feathers, *Working Effectively with Legacy Code* (Prentice Hall, 2004) — seam vocabulary. Brooks, *The Mythical Man-Month* (1975) — "conceptual integrity is the most important consideration in system design."

## [Never Block on the Human](./never-block-on-the-human.md)

Agent-era operating principle (consensus-backed, per the promotion bar's authoritative-backing branch): Osmani, "Loop Engineering" (addyosmani.com, 2026) — asynchronous supervision of agent loops; "your job is to ship code you confirmed works." pstack, `principle-never-block-on-the-human` (cursor/plugins) — an independent implementation, including the reversible/irreversible boundary. On the stopping half: Toyota Production System's andon cord — "stop the line on any defect" — see Liker, *The Toyota Way* (McGraw-Hill, 2004), and Imai, *Kaizen* (McGraw-Hill, 1986); Hunt & Thomas, *The Pragmatic Programmer* (20th Anniversary Edition, 2019), Topic 27, "Don't outrun your headlights."

## [Observability](./observability.md)

Majors, Fong-Jones, Miranda, *Observability Engineering* (O'Reilly, 2022) — high-cardinality structured events as the foundation of modern observability. Beyer, Jones, Petoff, Murphy, *Site Reliability Engineering* (O'Reilly, 2016); Beyer, Murphy, Rensin, Kawahara, Thorne, *The Site Reliability Workbook* (O'Reilly, 2018) — SLI/SLO/error-budget framework; alert on user-visible symptoms. Brendan Gregg, *Systems Performance* (2nd ed., Pearson, 2020) — the USE method (utilization, saturation, errors) for resource-level observability. RED (rate, errors, duration) is Tom Wilkie's complementary service-level framing.

## [Prove It Works](./prove-it-works.md)

Dijkstra, "Notes on Structured Programming" (EWD 249, 1970) — "Program testing can be used to show the presence of bugs, but never to show their absence." Beck, *Test-Driven Development by Example* (Addison-Wesley, 2002) — automated tests as proof of behavior. Goodhart's Law (Goodhart, 1975; popularized by Strathern, 1997) — when a measure becomes a target, it ceases to be a good measure. Verify the real thing, not the proxy.

## [Redesign From First Principles](./redesign-from-first-principles.md)

Brooks, *The Mythical Man-Month* (1975), chapter 11 "Plan to Throw One Away" — the first system you build is rarely the right one. Fowler, *Refactoring* (2nd ed., 2018) — refactor toward the design you'd choose now, in small steps.

## [Serialize Shared-State Mutations](./serialize-shared-state-mutations.md)

Lamport, "Time, Clocks, and the Ordering of Events in a Distributed System" (CACM 21:7, 1978) — ordering and causality in concurrent systems. Hoare, "Communicating Sequential Processes" (CACM, 1978; book Prentice Hall, 1985) — channels-and-processes model that informs Go's concurrency primitives. Kleppmann, *Designing Data-Intensive Applications* (2017) — serialization, locks, and transactional isolation in practice.

## [Subtract Before You Add](./subtract-before-you-add.md)

Saint-Exupéry, *Wind, Sand and Stars* (1939) — "Perfection is finally attained not when there is no longer anything to add, but when there is no longer anything to take away." Brooks, *The Mythical Man-Month* (1975) — second-system effect; less is more. Hunt & Thomas, *The Pragmatic Programmer* (1999) — "Program Deliberately" (the antidote to programming by coincidence) and the DRY principle. Fowler, "StranglerFigApplication" (martinfowler.com bliki, 2004) — incremental replacement of legacy systems for caller migration. Fowler, "Yagni" (martinfowler.com bliki, 2015) — the reuse ladder's first rung. Fowler, *Refactoring* (2nd ed., 2018) — refactor in the direction of deletion.

## [Surgical Changes](./surgical-changes.md)

Fowler, *Refactoring* (2nd ed., 2018) — Kent Beck's "Two Hats" metaphor: refactoring and adding function are distinct modes; never wear both at once in a single change. Beck, *Tidy First?* (O'Reilly, 2023) — distinguishes "tidyings" (small structural changes) from behavioral changes, and argues they belong in separate commits/PRs.

## [Threat Modeling](./threat-modeling.md)

Saltzer & Schroeder, "The Protection of Information in Computer Systems" (*Proc. IEEE* 63:1278-1308, 1975) — least privilege, fail-safe defaults, complete mediation, separation of privilege, economy of mechanism. Shostack, *Threat Modeling: Designing for Security* (Wiley, 2014) — STRIDE methodology and operational threat modeling. Schneier, *Secrets and Lies* (Wiley, 2000) — "attacks always get better"; security as a continuous discipline.
