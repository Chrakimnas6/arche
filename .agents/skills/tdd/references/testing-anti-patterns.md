# Testing Anti-Patterns

**Load this reference when:** writing or changing tests, adding mocks, or tempted to add test-only methods to production code.

## Overview

Tests must verify real behavior, not mock behavior. Mocks are a means to isolate, not the thing being tested.

**Core principle:** Test what the code does, not what the mocks do.

**Following strict TDD prevents these anti-patterns.**

## The Iron Laws

```
1. NEVER test mock behavior
2. NEVER add test-only methods to production structs
3. NEVER mock without understanding dependencies
```

## Name the Break (before writing any test)

A test earns its place by catching a *specific* break: a wrong branch, a missing side effect, a wrong argument, a boundary case, a broken contract. Before writing the test body, name the production change that would make this test fail — and confirm that change is a **bug**, not a **decision**. If you can't name one, the test proves nothing; redesign it around an observable behavior.

**No change detectors.** A test that fails only when someone makes an *intentional* change — a constant's value, exact wording, private structure — fires on every redesign and sleeps through real bugs. Test the behavior that depends on the decision, not the decision itself:

```go
// BAD: change detector — fails on a deliberate retune, catches no bug
if MaxRetries != 5 { t.Fatalf("got %d", MaxRetries) }

// GOOD: the behavior the constant governs
// a failing call is retried 5 times and the 6th attempt never happens
```

**Behavior, not text.** Asserting that a script, skill doc, or config *contains* an exact line proves only that the source is the source — it can't catch a behavioral break and fires on every reword. Run the artifact against controlled inputs and assert its outputs, side effects, or exit code. (`tests/validate-setup.sh` checks existence and structure, not prose; agent-facing docs are "tested" by the consuming agent's behavior; prose for humans earns no test.)

**Your code, not the framework.** Test the contract *your* code makes at its boundaries — the route you register, the query you emit, the payload you produce — not the framework's documented mechanics (asserting your router invokes a handler you registered is the framework's test to write, not yours). The same line applies inside your code: constructors, getters, trivial forwarders, and constants earn a test only when they validate, normalize, default, derive, enforce, or cause a side effect; otherwise assert the first consumer-visible result that depends on them.

### Gate Function

```
BEFORE writing the test body:
  Name the production change that would make this test fail.

  Cannot name one            -> redesign around an observable behavior
  "The source text changed"  -> run the artifact, assert its effects
  Only an intentional choice -> change detector; test the behavior
                                that depends on the choice, not the choice
```

## Anti-Pattern 1: Testing Mock Behavior

**The violation:**
```go
// BAD: Testing that the mock exists
func TestRendersSidebar(t *testing.T) {
	page := NewPage(mockSidebar{})
	if page.Sidebar == nil {
		t.Fatal("expected sidebar mock to be present")
	}
}
```

**Why this is wrong:**
- You're verifying the mock works, not that the component works
- Test passes when mock is present, fails when it's not
- Tells you nothing about real behavior

**The user's correction:** "Are we testing the behavior of a mock?"

**The fix:**
```go
// GOOD: Test real component or don't mock it
func TestRendersSidebar(t *testing.T) {
	page := NewPage(NewRealSidebar())
	nav := page.Navigation()
	if nav == nil {
		t.Fatal("expected page to have navigation")
	}
}

// OR if sidebar must be mocked for isolation:
// Don't assert on the mock - test Page's behavior with sidebar present
```

### Gate Function

```
BEFORE asserting on any mock element:
  Ask: "Am I testing real component behavior or just mock existence?"

  IF testing mock existence:
    STOP - Delete the assertion or use the real implementation

  Test real behavior instead
```

## Anti-Pattern 2: Test-Only Methods in Production

**The violation:**
```go
// BAD: Destroy() only used in tests
type Session struct {
	id               string
	workspaceManager *WorkspaceManager
}

func (s *Session) Destroy() error { // Looks like production API!
	if s.workspaceManager != nil {
		return s.workspaceManager.DestroyWorkspace(s.id)
	}
	return nil
}

// In tests
func TestSomething(t *testing.T) {
	session := newTestSession(t)
	t.Cleanup(func() { session.Destroy() })
}
```

**Why this is wrong:**
- Production struct polluted with test-only code
- Dangerous if accidentally called in production
- Violates YAGNI and separation of concerns
- Confuses object lifecycle with entity lifecycle

**The fix:**
```go
// GOOD: Test utilities handle test cleanup
// Session has no Destroy() - it's stateless in production

// In testutil/cleanup.go
func CleanupSession(t *testing.T, session *Session, wm *WorkspaceManager) {
	t.Helper()
	info := session.WorkspaceInfo()
	if info != nil {
		if err := wm.DestroyWorkspace(info.ID); err != nil {
			t.Errorf("cleanup session: %v", err)
		}
	}
}

// In tests
func TestSomething(t *testing.T) {
	session := newTestSession(t)
	t.Cleanup(func() { testutil.CleanupSession(t, session, wm) })
}
```

### Gate Function

```
BEFORE adding any method to production struct:
  Ask: "Is this only used by tests?"

  IF yes:
    STOP - Don't add it
    Put it in test utilities instead

  Ask: "Does this struct own this resource's lifecycle?"

  IF no:
    STOP - Wrong struct for this method
```

## Anti-Pattern 3: Mocking Without Understanding

**The violation:**
```go
// BAD: Mock breaks test logic
func TestDetectsDuplicateServer(t *testing.T) {
	// Mock prevents config write that test depends on!
	catalog := &mockToolCatalog{
		discoverAndCacheToolsFn: func() error { return nil },
	}

	svc := NewService(catalog)
	svc.AddServer(config) // Config never written because catalog is fully mocked
	err := svc.AddServer(config) // Should return error - but won't!
	if err == nil {
		t.Fatal("expected duplicate server error")
	}
}
```

**Why this is wrong:**
- Mocked method had side effect test depended on (writing config)
- Over-mocking to "be safe" breaks actual behavior
- Test passes for wrong reason or fails mysteriously

**The fix:**
```go
// GOOD: Mock at correct level
func TestDetectsDuplicateServer(t *testing.T) {
	// Mock the slow part, preserve behavior test needs
	mgr := &mockServerManager{} // Just mock slow server startup

	svc := NewService(realCatalog, mgr)
	svc.AddServer(config) // Config written via real catalog
	err := svc.AddServer(config) // Duplicate detected
	if err == nil {
		t.Fatal("expected duplicate server error")
	}
}
```

### Gate Function

```
BEFORE mocking any method:
  STOP - Don't mock yet

  1. Ask: "What side effects does the real method have?"
  2. Ask: "Does this test depend on any of those side effects?"
  3. Ask: "Do I fully understand what this test needs?"

  IF depends on side effects:
    Mock at lower level (the actual slow/external operation)
    OR use test doubles that preserve necessary behavior
    NOT the high-level method the test depends on

  IF unsure what test depends on:
    Run test with real implementation FIRST
    Observe what actually needs to happen
    THEN add minimal mocking at the right level

  Red flags:
    - "I'll mock this to be safe"
    - "This might be slow, better mock it"
    - Mocking without understanding the dependency chain
```

## Anti-Pattern 4: Incomplete Mocks

**The violation:**
```go
// BAD: Partial mock - only fields you think you need
mockResponse := Response{
	Status: "success",
	Data: UserData{UserID: "123", Name: "Alice"},
	// Missing: Metadata that downstream code uses
}

// Later: panics when code accesses response.Metadata.RequestID
```

**Why this is wrong:**
- **Partial mocks hide structural assumptions** - You only mocked fields you know about
- **Downstream code may depend on fields you didn't include** - Silent failures
- **Tests pass but integration fails** - Mock incomplete, real API complete
- **False confidence** - Test proves nothing about real behavior

**The Iron Rule:** Mock the COMPLETE data structure as it exists in reality, not just fields your immediate test uses.

**The fix:**
```go
// GOOD: Mirror real API completeness
mockResponse := Response{
	Status: "success",
	Data:   UserData{UserID: "123", Name: "Alice"},
	Metadata: Metadata{
		RequestID: "req-789",
		Timestamp: 1234567890,
	},
	// All fields real API returns
}
```

### Gate Function

```
BEFORE creating mock responses:
  Check: "What fields does the real API response contain?"

  Actions:
    1. Examine actual API response from docs/examples
    2. Include ALL fields system might consume downstream
    3. Verify mock matches real response schema completely

  Critical:
    If you're creating a mock, you must understand the ENTIRE structure
    Partial mocks fail silently when code depends on omitted fields

  If uncertain: Include all documented fields
```

## Anti-Pattern 5: Tautological Assertions

**The violation:**
```go
// BAD: the assertion recomputes the result the same way the code does
func TestApplyDiscount(t *testing.T) {
	price, rate := 100.0, 0.1
	got := ApplyDiscount(price, rate)
	if got != price-price*rate { // same formula as the implementation
		t.Fatalf("got %v", got)
	}
}
```

**Why this is wrong:**
- The expected value is derived the way the code derives it, so it passes by construction
- If `ApplyDiscount` uses the wrong formula, the test copies the mistake and still agrees
- The test can never disagree with the code — it proves the code equals itself, not that it's correct
- Snapshots regenerated by the code under test and constants asserted equal to themselves fail the same way

**The Iron Rule:** Expected values must come from an independent source of truth — a known-good literal, a worked example, or the spec — never recomputed by the code path under test.

**The fix:**
```go
// GOOD: expected value is an independent, worked-out result
func TestApplyDiscount(t *testing.T) {
	got := ApplyDiscount(100.0, 0.1)
	if got != 90.0 { // computed by hand from the spec, not from the code
		t.Fatalf("got %v, want 90.0", got)
	}
}
```

### Gate Function

```
BEFORE writing an assertion:
  Ask: "Where does my expected value come from?"

  IF it is produced the same way the code produces it
     (same formula, a snapshot the code regenerates, a constant equal to itself):
    STOP - the test passes by construction and can never catch a bug

  Expected values must come from an independent source:
    a known-good literal, a worked example, or the spec
```

## Anti-Pattern 6: Integration Tests as Afterthought

**The violation:**
```
Implementation complete
No tests written
"Ready for testing"
```

**Why this is wrong:**
- Testing is part of implementation, not optional follow-up
- TDD would have caught this
- Can't claim complete without tests

**The fix:**
```
TDD cycle:
1. Write failing test
2. Implement to pass
3. Refactor
4. THEN claim complete
```

## When Mocks Become Too Complex

**Warning signs:**
- Mock setup longer than test logic
- Mocking everything to make test pass
- Mocks missing methods real components have
- Test breaks when mock changes

**The user's question:** "Do we need to be using a mock here?"

**Consider:** Integration tests with real components often simpler than complex mocks

## The Mutation Check

Before calling a test file done, mentally mutate the production code: for each realistic mutation, at least one test should fail. If nothing fails, the behavior is unprotected — or the test is tautological.

Mutations to try:

- Wrong constant or argument
- Wrong branch handler
- Missing state change or side effect
- Empty or default return value
- Missing validation for zero, empty, nil, unauthorized, or malformed input

## Ship Only the Tests the Behavior Needs

The TDD cycle — failing test, minimal code, refactor — is what "complete" means, but "complete" is not "maximal." Trivial code and human prose earn no test; a test written only to satisfy process (or chase a coverage number) checks no break and costs maintenance forever. Ship the tests the behavior needs and only those.

## TDD Prevents These Anti-Patterns

**Why TDD helps:**
1. **Write test first** - Forces you to think about what you're actually testing
2. **Watch it fail** - Confirms test tests real behavior, not mocks
3. **Minimal implementation** - No test-only methods creep in
4. **Real dependencies** - You see what the test actually needs before mocking

**If you're testing mock behavior, you violated TDD** - you added mocks without watching test fail against real code first.

## Quick Reference

| Anti-Pattern | Fix |
|--------------|-----|
| Can't name the break it catches | Redesign around an observable behavior, or don't write it |
| Change detector (constant/wording/structure) | Test the behavior that depends on the decision |
| Asserts a script/doc contains a line | Run the artifact, assert outputs/side effects/exit code |
| Tests the framework's mechanics | Test your boundary contract, not upstream mechanics |
| Assert on mock elements | Test real component or unmock it |
| Test-only methods in production | Move to test utilities |
| Mock without understanding | Understand dependencies first, mock minimally |
| Incomplete mocks | Mirror real API completely |
| Tautological assertion | Expected value from an independent source, not recomputed by the code |
| Tests as afterthought | TDD - tests first |
| Over-complex mocks | Consider integration tests |
| Test written for coverage/process | Delete it — ship only tests the behavior needs |

## Red Flags

- You can't name the production bug the test would catch
- The test fails on every intentional change but never on an accidental break
- The test greps source text, or asserts a removed symbol stays removed
- The test would still matter if only the framework remained (no logic of yours exercised)
- No realistic mutation of the production code makes the test fail
- Assertions that only verify a mock struct was injected
- Methods only called in test files
- Mock setup is >50% of test
- Test fails when you remove mock
- Can't explain why mock is needed
- Mocking "just to be safe"
- Expected value computed with the same formula or logic as the code under test

## The Bottom Line

**Mocks are tools to isolate, not things to test.**

If TDD reveals you're testing mock behavior, you've gone wrong.

Fix: Test real behavior or question why you're mocking at all.
