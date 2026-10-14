---
name: unslop
description: Cut AI tells from English prose people will read. Use before handing off a PR description, README, doc, or report written in English, or when asked to unslop, tighten, or de-AI a text.
---

# Unslop

Edit the target text to remove AI writing patterns. Scan for the patterns below, then rewrite, matching the intended tone. If the target is a file, edit it in place. Rules the user adds in the request ("no em dashes") override the ones here.

## Keep the meaning

Before rewriting a sentence, note four things about it, and check them again after:

1. **Claim:** what it says, including how its parts relate logically.
2. **Weight:** what it treats as most and least important. A rejected option stays rejected; don't turn it into "A as well as B".
3. **Certainty:** a firm statement stays firm, and a hedge keeps its strength.
4. **Function:** a fact stays a fact, an opinion stays an opinion, a request stays a request, a plan stays a plan.

Add no information. When cutting a phrase would lose a fact, keep the fact in plain words. When a sentence needs something the text doesn't say, ask instead of inventing it.

## Patterns to detect and fix

### Content

1. **Superficial -ing phrases.** "highlighting...", "ensuring...", "reflecting...", "showcasing...", "fostering...". Delete, or expand with real sources.
2. **Vague attributions.** "Experts believe", "Industry reports suggest", "Some critics argue". Name the source or delete.

### Language

3. **AI vocabulary.** Additionally, crucial, delve, enduring, enhance, fostering, garner, interplay, intricate, landscape (abstract), pivotal, showcase, tapestry (abstract), testament, underscore, vibrant. Replace with plain words.
4. **Fancy ways to say "is".** "serves as", "stands as", "boasts", "features". Say "is" or "has".
5. **"Not just X, but Y."** State the point directly.
6. **Rule of three.** Don't force ideas into groups of three. Use the natural number.
7. **Synonym cycling.** Protagonist, main character, central figure, and hero in one paragraph. Pick one and repeat it.
8. **False ranges.** "from X to Y" where X and Y aren't on a meaningful scale. List the topics directly.

### Style

9. **Dash overuse.** At most one em dash per paragraph, and never as the default joint between clauses. Prefer a period or a comma.
10. **Colon overuse.** A colon is fine before a list or an example, not as a mid-sentence connector. "If you're coming from traditional automation: instead of registering event handlers, you describe conditions" becomes "Describing when the scheduler should fire works best as plain English."
11. **Boldface overuse.** Don't bold every proper noun or acronym.
12. **Inline-header lists.** The tell is a bold label and colon that restates the line: "**Performance:** Performance improved...". Convert those to prose. A bold lead-in that ends in a period, names the item, and is followed by new detail ("**Schema in TypeScript.** Tables live in one file.") is fine.
13. **Heading case.** Match the document's existing heading case; use sentence case in a new document.
14. **Decorative emojis.** Remove them from headings and bullets.
15. **Curly quotes.** Use straight quotes.

### Communication artifacts

16. **Chatbot phrases.** "I hope this helps!", "Let me know if...", "Of course!", "Certainly!", "Found the smoking gun!" Remove.
17. **Sycophantic tone.** "Great question! You're absolutely right!" Respond directly.

### Filler

18. **Filler phrases.** "In order to" becomes "To". "Due to the fact that" becomes "Because". Delete "It is important to note that".
19. **Stacked hedging.** "could potentially possibly be argued that it might" becomes "may". Keep one hedge at the original strength.
20. **Generic conclusions.** "The future looks bright." State specific plans or facts.

### Jargon

21. **Abstract metaphor nouns.** Substrate (base), wedge, wedge in (add), vector (way, method), locus, vantage, nexus, primitive as a noun, harness as a metaphor, surface as in "API surface", bedrock, scaffolding as a metaphor, modality, paradigm, gold-plating (more than the job needs), ratchet as a metaphor (the mechanism's real name, or a limit that only tightens), evacuate for moving code (move out), endgame (the last phase), north star, flywheel. Pick the concrete word.

### Plain speech

22. **Say what it does, not how it feels.** "the database stays close at hand", "SQL you can read", "types that follow your schema" name a feeling. Name the mechanism or a number instead: "`.toSQL()` returns the exact string sent to the database", "a column rename fails the build". If you can't restate a sentence as a concrete instruction, fact, or number, cut it. If it could appear unchanged in another project's docs, it says nothing about this one; cut it.
23. **Shorten or split dense sentences.** If the reader has to backtrack to parse a sentence, break it in two or drop clauses. One idea per sentence.
24. **Active voice.** Catch "is/are/was/were + past participle" and name the actor: "queries are validated" becomes "the compiler validates queries". Passive is fine only when the actor is unknown or doesn't matter.
25. **Cut adverbs, or use a stronger verb.** "runs quickly" becomes "is fast" or the number; "significantly improves" becomes the measured delta.
26. **Prefer the plain word.** "utilize" and "leverage" become "use", "facilitate" becomes "help", "numerous" becomes "many", "in the event that" becomes "if".
27. **Mannered prose.** Metaphor or flourish where a literal phrase exists: aphorisms ("wire it or delete it"), rhetorical fragments for effect, personified code ("the plan holds it"), figurative verbs ("rides along", "stands on"), stock framing phrases. "A dial worth turning" becomes "a parameter worth varying". Rule 21 covers the metaphor nouns.
28. **Over-compression.** Dropped articles, verbless fragments, arrows, symbol-speak, and abbreviations that make the reader decode instead of read. "Parser rejects bad date → exit 2, no write" becomes "The parser rejects a bad date, exits with code 2, and writes nothing."
