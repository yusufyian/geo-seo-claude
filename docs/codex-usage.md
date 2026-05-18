# Codex Usage

This repository is branded and installed as a Claude Code skill bundle, but most of its content is usable from Codex after a small shift in workflow.

## What Works Directly

- `geo/SKILL.md` can be used as the main GEO/SEO playbook.
- `skills/geo-*/SKILL.md` files can be read as task-specific instructions.
- `scripts/*.py` are ordinary Python utilities.
- `schema/*.json` templates are reusable JSON-LD examples.
- `docs/` and `examples/` provide reference outputs and methodology.

## What Is Claude-Specific

- `/geo ...` slash commands are Claude Code command conventions, not native Codex commands.
- `install.sh` and `install-win.sh` install into `~/.claude/skills` and `~/.claude/agents`.
- Many skill files reference Claude tool names such as `WebFetch`, `Read`, `Grep`, `Glob`, `Bash`, and `Write`.
- `agents/*.md` are Claude-style subagent definitions. Codex can use them as role instructions, but they are not automatically registered.

## Recommended Codex Workflow

For a user request such as “run a GEO audit for https://example.com”:

1. Read `geo/SKILL.md` for the command flow and scoring model.
2. Read the relevant specialized skill, such as `skills/geo-audit/SKILL.md` or `skills/geo-citability/SKILL.md`.
3. Run local Python helpers from `scripts/` when deterministic extraction or scoring is needed.
4. Use `agents/*.md` as reference roles if splitting analysis into parallel work is useful.
5. Write outputs into the current workspace unless the user asks for another location.

## Local Setup

Use a repo-local virtual environment:

```bash
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
pytest
```

For Codex work, prefer relative paths such as `scripts/fetch_page.py` over hard-coded Claude paths like `~/.claude/skills/geo/scripts/fetch_page.py`.

## Optional Codex Install

To install the bundle as local Codex skills, run:

```bash
./install-codex.sh
```

The installer copies:

- Main skill to `~/.codex/skills/geo/`
- Sub-skills to `~/.codex/skills/geo-*/`
- Agent reference files to `~/.codex/agents/`
- Python scripts and schema templates under `~/.codex/skills/geo/`

It also creates an isolated venv at `~/.codex/skills/geo/.venv/` and rewrites installed Markdown references from Claude paths to Codex paths.

If your Codex runtime reads skills from a different directory, override the target:

```bash
CODEX_SKILLS_DIR=/path/to/skills CODEX_AGENTS_DIR=/path/to/agents ./install-codex.sh
```

To remove the installed Codex copy:

```bash
./uninstall-codex.sh
```

## Compatibility Position

Codex can reuse the project’s knowledge base, scripts, schema templates, and report structure. It should not assume 100% compatibility with the Claude Code installation model, slash command registry, or subagent loader.
