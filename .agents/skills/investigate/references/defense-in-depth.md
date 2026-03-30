# Defense-in-Depth Validation

## Overview

When you fix a bug caused by invalid data, adding validation at one place feels sufficient. But that single check can be bypassed by different code paths, refactoring, or mocks.

**Core principle:** Validate at EVERY layer data passes through. Make the bug structurally impossible.

## Why Multiple Layers

Single validation: "We fixed the bug"
Multiple layers: "We made the bug impossible"

Different layers catch different cases:
- Entry validation catches most bugs
- Business logic catches edge cases
- Environment guards prevent context-specific dangers
- Debug logging helps when other layers fail

## The Four Layers

### Layer 1: Entry Point Validation
**Purpose:** Reject obviously invalid input at API boundary

```go
func CreateProject(name, workingDirectory string) error {
    if strings.TrimSpace(workingDirectory) == "" {
        return fmt.Errorf("workingDirectory cannot be empty")
    }

    info, err := os.Stat(workingDirectory)
    if os.IsNotExist(err) {
        return fmt.Errorf("workingDirectory does not exist: %s", workingDirectory)
    }
    if err != nil {
        return fmt.Errorf("checking workingDirectory: %w", err)
    }
    if !info.IsDir() {
        return fmt.Errorf("workingDirectory is not a directory: %s", workingDirectory)
    }

    // ... proceed
    return nil
}
```

### Layer 2: Business Logic Validation
**Purpose:** Ensure data makes sense for this operation

```go
func InitializeWorkspace(projectDir, sessionID string) error {
    if projectDir == "" {
        return fmt.Errorf("projectDir required for workspace initialization")
    }
    // ... proceed
    return nil
}
```

### Layer 3: Environment Guards
**Purpose:** Prevent dangerous operations in specific contexts

```go
func gitInit(directory string) error {
    // In tests, refuse git init outside temp directories
    if os.Getenv("GO_ENV") == "test" {
        normalized, err := filepath.Abs(directory)
        if err != nil {
            return fmt.Errorf("resolving directory: %w", err)
        }
        tmpDir := os.TempDir()

        if !strings.HasPrefix(normalized, tmpDir) {
            return fmt.Errorf(
                "refusing git init outside temp dir during tests: %s", directory,
            )
        }
    }
    // ... proceed
    return nil
}
```

### Layer 4: Debug Instrumentation
**Purpose:** Capture context for forensics

```go
func gitInit(directory string) error {
    log.Printf("About to git init: directory=%s cwd=%s\nstack:\n%s",
        directory,
        mustGetwd(),
        string(debug.Stack()),
    )
    // ... proceed
    return nil
}
```

## Applying the Pattern

When you find a bug:

1. **Trace the data flow** - Where does bad value originate? Where used?
2. **Map all checkpoints** - List every point data passes through
3. **Add validation at each layer** - Entry, business, environment, debug
4. **Test each layer** - Try to bypass layer 1, verify layer 2 catches it

## Example from Session

Bug: Empty `projectDir` caused `git init` in source code

**Data flow:**
1. Test setup -> empty string
2. `Project.Create(name, "")`
3. `WorkspaceManager.CreateWorkspace("")`
4. `git init` runs in current working directory

**Four layers added:**
- Layer 1: `Project.Create()` validates not empty/exists/writable
- Layer 2: `WorkspaceManager` validates projectDir not empty
- Layer 3: `WorktreeManager` refuses git init outside tmpdir in tests
- Layer 4: Stack trace logging before git init

**Result:** All 1847 tests passed, bug impossible to reproduce

## Key Insight

All four layers were necessary. During testing, each layer caught bugs the others missed:
- Different code paths bypassed entry validation
- Mocks bypassed business logic checks
- Edge cases on different platforms needed environment guards
- Debug logging identified structural misuse

**Don't stop at one validation point.** Add checks at every layer.
