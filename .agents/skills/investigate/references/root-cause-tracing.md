# Root Cause Tracing

## Overview

Bugs often manifest deep in the call stack (git init in wrong directory, file created in wrong location, database opened with wrong path). Your instinct is to fix where the error appears, but that's treating a symptom.

**Core principle:** Trace backward through the call chain until you find the original trigger, then fix at the source.

## When to Use

**Use when:**
- Error happens deep in execution (not at entry point)
- Stack trace shows long call chain
- Unclear where invalid data originated
- Need to find which test/code triggers the problem

## The Tracing Process

### 1. Observe the Symptom
```
Error: git init failed in /Users/jesse/project/packages/core
```

### 2. Find Immediate Cause
**What code directly causes this?**
```go
cmd := exec.Command("git", "init")
cmd.Dir = projectDir
if err := cmd.Run(); err != nil {
    return fmt.Errorf("git init failed: %w", err)
}
```

### 3. Ask: What Called This?
```go
WorktreeManager.CreateSessionWorktree(projectDir, sessionID)
  -> called by Session.InitializeWorkspace()
  -> called by Session.Create()
  -> called by test at Project.Create()
```

### 4. Keep Tracing Up
**What value was passed?**
- `projectDir = ""` (empty string!)
- Empty string as `Dir` resolves to the current working directory
- That's the source code directory!

### 5. Find Original Trigger
**Where did empty string come from?**
```go
ctx := setupCoreTest() // Returns &TestContext{TempDir: ""}
project.Create("name", ctx.TempDir) // Accessed before test setup ran!
```

## Adding Stack Traces

When you can't trace manually, add instrumentation:

```go
// Before the problematic operation
func gitInit(directory string) error {
    log.Printf("DEBUG git init: directory=%s cwd=%s env=%s\nstack:\n%s",
        directory,
        mustGetwd(),
        os.Getenv("GO_ENV"),
        string(debug.Stack()),
    )

    cmd := exec.Command("git", "init")
    cmd.Dir = directory
    return cmd.Run()
}
```

**Critical:** Use `log.Printf()` or `fmt.Fprintf(os.Stderr, ...)` in tests (not a logger that may be suppressed)

**Run and capture:**
```bash
go test ./... 2>&1 | grep 'DEBUG git init'
```

**Analyze stack traces:**
- Look for test file names
- Find the line number triggering the call
- Identify the pattern (same test? same parameter?)

## Finding Which Test Causes Pollution

If something appears during tests but you don't know which test:

Run tests one-by-one using bisection to find the first polluter.

## Real Example: Empty projectDir

**Symptom:** `.git` created in `packages/core/` (source code)

**Trace chain:**
1. `git init` runs in current working directory <- empty Dir field
2. WorktreeManager called with empty projectDir
3. Session.Create() passed empty string
4. Test accessed `ctx.TempDir` before test setup ran
5. setupCoreTest() returns `&TestContext{TempDir: ""}` initially

**Root cause:** Top-level variable initialization accessing empty value

**Fix:** Made TempDir a method that panics if accessed before setup

**Also added defense-in-depth:**
- Layer 1: Project.Create() validates directory
- Layer 2: WorkspaceManager validates not empty
- Layer 3: GO_ENV guard refuses git init outside tmpdir
- Layer 4: Stack trace logging before git init

## Key Principle

**NEVER fix just where the error appears.** Trace back to find the original trigger.

## Stack Trace Tips

**In tests:** Use `log.Printf()` or `t.Logf()` - custom loggers may be suppressed
**Before operation:** Log before the dangerous operation, not after it fails
**Include context:** Directory, cwd, environment variables, timestamps
**Capture stack:** `debug.Stack()` shows complete call chain
