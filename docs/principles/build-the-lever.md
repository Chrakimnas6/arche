# Build the Lever

**Principle:** When work is non-trivial, build the tool that does it or proves it — a codemod, script, generator, or check — instead of working by hand. The tool is the artifact a reviewer can rerun.

**Apply when** work is non-trivial and a script, codemod, or generator would make it checkable or materially safer than hand edits.

**Why:** hand-done changes can only be re-verified by redoing them; a deterministic lever turns "trust me" into "run this."

## Pattern

- **Learn by hand, then mechanize.** Do the first unit manually to learn the recipe, then build the lever and prove it by rerunning it on that unit and diffing against the hand-done version.
- **A deterministic lever beats fan-out.** If a script can process every unit in one pass, run it; don't spawn delegates to hand-apply what a script can do.
- **When you do fan out, the lever is the shared recipe.** Write it once (a script or a skill every delegate reads) so delegates inherit one hardened version instead of drifting per prompt.
- **Commit the lever when the work outlives the session**, so the next run reruns it instead of redoing it.

## The Bar

**Triviality, not repetition.** A one-off still earns a lever *when the lever is what makes the work checkable*; a couple of obvious edits you can see at a glance never does. Build the smallest script that does or proves the job, never a framework. If a plan cites this principle, the lever must appear in the diff as a script, codemod, generator, or delegate-skill — but don't manufacture a tool to satisfy the citation.
