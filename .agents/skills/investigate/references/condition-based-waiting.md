# Condition-Based Waiting

## Overview

Flaky tests often guess at timing with arbitrary delays. This creates race conditions where tests pass on fast machines but fail under load or in CI.

**Core principle:** Wait for the actual condition you care about, not a guess about how long it takes.

## When to Use

**Use when:**
- Tests have arbitrary delays (`time.Sleep`, `time.After`)
- Tests are flaky (pass sometimes, fail under load)
- Tests timeout when run in parallel
- Waiting for async operations to complete

**Don't use when:**
- Testing actual timing behavior (debounce, throttle intervals)
- Always document WHY if using arbitrary timeout

## Core Pattern

```go
// BAD: Guessing at timing
time.Sleep(50 * time.Millisecond)
result := getResult()
if result == nil {
    t.Fatal("expected result to be defined")
}

// GOOD: Waiting for condition
result := waitFor(t, func() any {
    return getResult()
}, "result to be available")
if result == nil {
    t.Fatal("expected result to be defined")
}
```

## Quick Patterns

| Scenario | Pattern |
|----------|---------|
| Wait for event | `waitFor(t, func() any { return findEvent(events, "DONE") }, "DONE event")` |
| Wait for state | `waitFor(t, func() any { if machine.State() == "ready" { return true }; return nil }, "ready state")` |
| Wait for count | `waitFor(t, func() any { if len(items) >= 5 { return true }; return nil }, "5 items")` |
| Wait for file | `waitFor(t, func() any { if _, err := os.Stat(path); err == nil { return true }; return nil }, "file exists")` |
| Complex condition | `waitFor(t, func() any { if obj.Ready && obj.Value > 10 { return true }; return nil }, "ready with value")` |

## Implementation

Generic polling function:

```go
func waitFor(t *testing.T, condition func() any, description string, opts ...time.Duration) any {
    t.Helper()

    timeout := 5 * time.Second
    if len(opts) > 0 {
        timeout = opts[0]
    }

    deadline := time.After(timeout)
    ticker := time.NewTicker(10 * time.Millisecond) // Poll every 10ms
    defer ticker.Stop()

    for {
        select {
        case <-deadline:
            t.Fatalf("Timeout waiting for %s after %v", description, timeout)
            return nil
        case <-ticker.C:
            if result := condition(); result != nil {
                return result
            }
        }
    }
}
```

## Common Mistakes

**Polling too fast:** `time.NewTicker(1 * time.Millisecond)` - wastes CPU
**Fix:** Poll every 10ms

**No timeout:** Loop forever if condition never met
**Fix:** Always include timeout with clear error

**Stale data:** Cache state before loop
**Fix:** Call getter inside loop for fresh data

## When Arbitrary Timeout IS Correct

```go
// Tool ticks every 100ms - need 2 ticks to verify partial output
waitForEvent(t, manager, "TOOL_STARTED")        // First: wait for condition
time.Sleep(200 * time.Millisecond)               // Then: wait for timed behavior
// 200ms = 2 ticks at 100ms intervals - documented and justified
```

**Requirements:**
1. First wait for triggering condition
2. Based on known timing (not guessing)
3. Comment explaining WHY
