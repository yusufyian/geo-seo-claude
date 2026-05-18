# Repository Guidelines

## Project Structure & Module Organization

This repository packages a GEO/SEO skill bundle with reusable Python utilities. The main orchestrator lives in `geo/SKILL.md`. Specialized skills are in `skills/geo-*/SKILL.md`, and Claude-style subagent prompts are in `agents/*.md`. Python helpers are in `scripts/`, JSON-LD templates are in `schema/`, documentation is in `docs/`, examples are in `examples/`, and tests are in `tests/`.

For Codex, treat the Markdown skill files as operating instructions, not automatically registered commands. When asked for a GEO audit or related task, read `geo/SKILL.md`, then use the relevant `skills/geo-*` guide and `scripts/*.py` helper.

## Build, Test, and Development Commands

Create a local environment before running scripts:

```bash
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
```

Run tests with:

```bash
pytest
```

Useful script examples:

```bash
python scripts/fetch_page.py https://example.com page
python scripts/citability_scorer.py https://example.com/blog/post
python scripts/llmstxt_generator.py https://example.com
```

The `install.sh` and `install-win.sh` scripts install the bundle into `~/.claude/`; do not run them for Codex-specific setup unless you intentionally want Claude Code integration.

## Coding Style & Naming Conventions

Use Python 3.8+ compatible code. Follow existing script style: clear functions, standard-library parsing where practical, and minimal global side effects. Keep file and directory names lowercase with hyphens for skills (`geo-citability`) and snake_case for Python modules (`fetch_page.py`). Markdown skills should keep YAML frontmatter intact.

## Testing Guidelines

Tests use `pytest` and should live under `tests/` with names like `test_fetch_page_ssr.py`. Prefer mocked network responses for deterministic behavior. Add tests when changing parsing, scoring, crawler handling, schema extraction, or report generation.

## Commit & Pull Request Guidelines

Git history uses a mix of imperative conventional commits, for example `feat: add ...`, `fix: validate ...`, and `docs: initial ...`. Keep commit subjects under 72 characters when possible. Pull requests should describe the change, list tests run, link related issues, and include screenshots or sample output for report/UI changes.

## Security & Configuration Tips

Do not commit generated client data, local virtual environments, or files from `~/.geo-prospects/`. Be careful with live URL fetching in tests and examples; prefer stable fixtures or mocked responses.
