Цель: инженерный каркас репозитория; `cmake --preset server-debug` должен
конфигуриться и собираться на машине БЕЗ Qt/OSG/VSG.

- [ ] CMake-опция `OPENMW_MP_SERVER_ONLY` (default OFF): при ON пропускает
      find_package графики/Qt/звука и не собирает клиентские apps.
      Правки апстрима минимальны, каждая с маркером `// [MP]`.
- [ ] `CMakePresets.json`: пресет `server-debug` (Ninja, RelWithDebInfo,
      ccache, OPENMW_MP_SERVER_ONLY=ON).
- [ ] `apps/openmwmp/`: заглушка `openmw-mp-server` (main: печатает версию,
      возвращает 0) — точка роста будущего authoritative-сервера.
- [ ] `scripts/dev/build.sh`, `test.sh`, `verify.sh`
      (verify = configure+build + ctest + clang-format --dry-run по изменённым файлам).
- [ ] `extern/GameNetworkingSockets` оформить как git-submodule с pin-коммитом;
      fallback-клон из `scripts/dev/qwen-setup.sh` убрать.
- [ ] `.github/workflows/mp-ci.yml`: ubuntu-latest, запускает qwen-setup.sh + verify.sh на PR в mp/develop.
- [ ] `docs/ARCHITECTURE.md`: fork point (tag openmw-0.52.0 + SHA), топология
      (authoritative server, GNS, mod-manifest), roadmap этапов 1–5.

Acceptance: `bash scripts/dev/verify.sh` зелёный локально и в CI;
в PR приложен вывод ctest и список тронутых апстрим-файлов.