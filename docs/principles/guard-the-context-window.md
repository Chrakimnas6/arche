# Guard the Context Window

**Principle:** The context window is finite and non-renewable within a session. Every token that enters should earn its place — route bulk to subagents, keep summaries in the main thread.

**Apply when** context is filling up: large outputs, long files, repeated reads, or fan-out planning.

## Why

Context overflow degrades reasoning quality, forces lossy compression, and can halt progress entirely. Unlike compute or wall-clock time, context spent inside a session cannot be reclaimed — a wasted read is permanent for that session. This is the agent-side analogue of a human's working memory: the constraint that makes everything else (delegation, selective reading, phase sizing) necessary.

## The Pattern

- **Isolate large payloads.** Route verbose command output, long documents, screenshots, and broad exploration to subagents. The main context receives conclusions and summaries, not raw data.
- **Don't read what you won't use.** Read selectively based on relevance — this principles index's selective-read protocol is one application.
- **Keep hot content inline.** Templates and references used on every invocation belong in the skill file itself; separate files cost a read each time. Cold reference material belongs in separate files for the opposite reason.
- **Size phases and cap scope.** Limit files per phase and account for mechanism costs (tool schemas, transcripts) when planning long work. Before a wide delegate fan-out, pilot one slice to gauge what a delegate consumes and what its return adds to the main thread — then size the full run.
- **Summarize at boundaries.** When work crosses a session or compaction boundary, write the state down *outside* the context (a file), not just in it.

## Relationship to Other Principles

[Module depth](./module-depth.md) minimizes the *human reader's* load at interfaces; this minimizes the *agent's* working-context load during execution. Same economy, different consumer.

[Encode lessons in structure](./encode-lessons-in-structure.md) — selective-read protocols and summaries-not-payloads rules belong in mechanisms (index triggers, skill instructions), not in per-session discipline.

## Citations

Agent-era operating principle (consensus-backed, per the promotion bar's authoritative-backing branch): Anthropic, "Effective context engineering for AI agents" (engineering blog, 2025) — context as a finite resource; curation over accumulation. The context-engineering practitioner literature, 2025–2026 (the term's broad adoption across frontier-lab guidance and tooling docs). pstack, `principle-guard-the-context-window` (cursor/plugins) — an independent implementation of the same rule.
