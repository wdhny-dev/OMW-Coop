# AGENTS.md — OpenMW Multiplayer (co-op) project rules

## Project
Co-op multiplayer for OpenMW 0.51.0 (Morrowind). This repo is a fork of OpenMW;
all multiplayer code lives in `components/multiplayer/` and `apps/openmwmp/`.
Upstream must stay merge-friendly: never reformat or move upstream code;
MP hooks are small patches marked with `// [MP]` comments.

## Build / test (single source of truth)
- Configure: `cmake --preset server-debug`
- Build:     `cmake --build --preset server-debug`
- Tests:     `ctest --preset server-debug`
- Gate before EVERY commit: `bash scripts/dev/verify.sh`
  (build + ctest + clang-format/clang-tidy on touched files). No exceptions.

## Style
- C++20; root `.clang-format` / `.clang-tidy` are law.
- Namespace `MP::` for all multiplayer code. No raw new/delete.
- Wire formats ONLY via schemas in `components/multiplayer/schema/` (generated code).

## Architecture invariants
- Server is authoritative for all world state; clients predict own player only.
- MP layer observes gameplay via events, never re-implements mechanics.
- Client and server mod lists must match exactly (SHA-256 manifest, load order included).

## Forbidden
- Modifying `extern/` submodules; committing binaries/.bsa/Morrowind assets.
- New third-party deps without a note in `docs/DEPS.md`.
- Force-push to `mp/*`; direct commits to `mp/develop` (humans included, except initial bootstrap).

## PR rules
- One issue = one branch `ai/<issue>-<slug>` = one PR referencing the issue.
- PR body must contain: ctest output excerpt, list of touched upstream files.
