# AGENTS.md — OpenMW Multiplayer (co-op) project rules

## Project
Co-op multiplayer for OpenMW (Morrowind). Fork point: tag openmw-0.51.0
(last stable release; 0.52.0 is in development on upstream master, rebase onto it
is tracked as a separate task). All multiplayer code lives in
`components/multiplayer/` and `apps/openmwmp/`.
...
## Build / test (single source of truth)
...
- Gate before EVERY commit: `bash scripts/dev/verify.sh`
  (build + ctest + clang-format/clang-tidy on touched files). No exceptions.
  Note: verify.sh itself is a deliverable of task 001; until it exists,
  the gate is manual `cmake --build` + `ctest`.

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