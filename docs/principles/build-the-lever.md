# Build the Lever

**Principle:** When work is non-trivial, build the tool that does it or proves it — a codemod, script, generator, or check — instead of working by hand. The tool is the artifact a reviewer can rerun.

**Apply when** work is non-trivial and a script, codemod, or generator would make it checkable or materially safer than hand edits.

## Why

Two payoffs. **Throughput:** a script does the work the same way every time and reruns for free. **Confidence:** the tool is one artifact a reviewer can read and rerun to check the work — hand-done changes can only be re-verified by redoing them. A deterministic lever turns "trust me" into "run this."

## The Pattern

- **Learn by hand, then mechanize.** Do the first unit manually to learn the recipe, then build the lever and prove it by rerunning it on that unit and diffing against the hand-done version.
- **Reuse before building.** Reach for existing tools first (formatters, codemod frameworks, `gofmt`-style fixers); build only what doesn't exist.
- **A deterministic lever beats fan-out.** If a script can process every unit in one pass, run it — don't spawn delegates to hand-apply what a script can do.
- **When you do fan out, the lever is the shared recipe.** Write it once (as a script or a skill all delegates read) so every delegate inherits the same hardened version instead of drifting per prompt.
- **Commit the lever when the work outlives the session**, so the next run reruns it instead of redoing it.

## The Balance

The bar is **triviality, not repetition** — a one-off still earns a lever *when the lever is what makes the work checkable*; a couple of obvious edits you can see at a glance never does. Build the smallest script that does or proves the job — never a framework ([subtract before you add](./subtract-before-you-add.md)). If a cited lever doesn't appear in the diff as a script, codemod, generator, or delegate-skill, the principle wasn't applied — but the converse also holds: don't manufacture a tool to satisfy the citation.

## Relationship to Other Principles

[Encode lessons in structure](./encode-lessons-in-structure.md) makes a *recurring instruction* a durable guardrail; this is throughput and reviewability on the work *in front of you*, even a one-off. [Prove it works](./prove-it-works.md) — the lever is often the verification script itself. [Subtract before you add](./subtract-before-you-add.md) bounds the lever's size.

## Citations

The codemod/mechanized-refactor tradition: `gofix` (Go team, 2011) and `jscodeshift` (Facebook, 2015) — large-scale changes as rerunnable, reviewable programs. Hunt & Thomas, *The Pragmatic Programmer* (1999) — code generators and "ubiquitous automation." pstack, `principle-build-the-lever` (cursor/plugins) — the reviewer-reruns-the-artifact framing.
