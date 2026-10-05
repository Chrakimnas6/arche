# Guard the Context Window

**Principle:** The context window is finite and non-renewable within a session. Every token that enters should earn its place — route bulk to subagents, keep summaries in the main thread.

**Apply when** context is filling up: large outputs, long files, repeated reads, or fan-out planning.

**Why:** context spent inside a session cannot be reclaimed, and overflow degrades reasoning and forces lossy compression.

## Pattern

- **Isolate large payloads.** Route verbose command output, long documents, screenshots, and broad exploration to subagents; the main context receives conclusions, not raw data.
- **Delegation costs context too.** Everything pasted into a dispatch prompt and everything a subagent prints back stays resident and is re-read every later turn. Hand large artifacts over as files (a brief, a report path), cap what a subagent returns inline, and write a dispatch prompt for one task, not the session's accumulated history.
- **Keep hot content inline.** Templates and references used on every invocation belong in the skill file itself, since a separate file costs a read each time; cold reference material belongs in separate files.
- **Size phases and cap scope.** Limit files per phase and account for mechanism costs (tool schemas, transcripts). Before a wide fan-out, pilot one slice to gauge what a delegate consumes and returns, then size the full run.
- **Write state down at boundaries.** Before a session or compaction boundary, record a ledger of what's done and the commits or artifacts proving it in a file, not just in context. After the boundary, trust the ledger and the durable record over recollection; the expensive failure is redoing completed work.
