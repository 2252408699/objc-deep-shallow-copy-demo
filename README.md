# Objective-C Deep and Shallow Copy Demo

This Foundation command-line project reproduces a notification-template editing bug. It compares a top-level mutable collection copy with an explicit application-level deep copy.

The executable verifies that:

- `mutableCopy` creates a new outer array;
- the copied array still contains the same mutable element objects;
- mutating a shared element changes what the original array observes;
- an explicit deep copy creates independent elements and nested metadata;
- editing the deep copy leaves the original template unchanged.

## Requirements

- macOS
- Xcode Command Line Tools (`xcode-select --install`)

## Run

```bash
git clone https://github.com/2252408699/objc-deep-shallow-copy-demo.git
cd objc-deep-shallow-copy-demo
make run
```

A successful run prints seven `PASS` lines and ends with `All copy-semantics checks passed.` Run `make clean` to remove the executable.
