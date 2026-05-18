# 中文使用说明

这个项目最初是为 Claude Code 设计的 GEO/SEO 技能包，但也可以通过 Codex 使用其中的大部分能力。它主要包含 Markdown 技能说明、Python 工具脚本、JSON-LD 模板、报告模板和示例文件。

## 目录作用

- `geo/SKILL.md`：主入口，定义 GEO 审计流程和命令路由。
- `skills/geo-*/SKILL.md`：具体能力说明，例如 citability、crawler、schema、content、technical audit。
- `agents/*.md`：Claude 风格的子 agent 角色说明，Codex 可作为分析角色参考。
- `scripts/*.py`：可直接运行的 Python 工具。
- `schema/*.json`：结构化数据 JSON-LD 模板。
- `docs/`：详细文档。
- `examples/`：审计报告和提案示例。

## 方式一：使用 Claude Code

这是项目默认使用方式。

```bash
./install.sh
```

Windows Git Bash 使用：

```bash
./install-win.sh
```

安装完成后重启 Claude Code，然后运行：

```text
/geo quick https://example.com
/geo audit https://example.com
/geo citability https://example.com/blog/post
/geo crawlers https://example.com
/geo schema https://example.com
/geo report https://example.com
```

Claude 版本会安装到：

```text
~/.claude/skills/geo/
~/.claude/skills/geo-*/
~/.claude/agents/
```

## 方式二：使用 Codex

如果你主要使用 Codex，运行：

```bash
./install-codex.sh
```

安装完成后重启 Codex，然后用自然语言调用，例如：

```text
使用 geo skill 对 https://example.com 做 GEO quick audit
检查 https://example.com 的 AI crawler、schema 和 citability
为 https://example.com 生成 GEO report
```

Codex 版本会安装到：

```text
~/.codex/skills/geo/
~/.codex/skills/geo-*/
~/.codex/agents/
```

如果你的 Codex skills 目录不同，可以指定路径：

```bash
CODEX_SKILLS_DIR=/path/to/skills CODEX_AGENTS_DIR=/path/to/agents ./install-codex.sh
```

卸载 Codex 安装副本：

```bash
./uninstall-codex.sh
```

## 方式三：直接运行 Python 脚本

适合开发、调试或只使用某个工具。

```bash
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
```

运行示例：

```bash
python scripts/fetch_page.py https://example.com page
python scripts/citability_scorer.py https://example.com/blog/post
python scripts/llmstxt_generator.py https://example.com
```

运行测试：

```bash
pytest
```

## Codex 兼容性说明

Codex 可以复用项目中的分析方法、技能说明、Python 脚本、schema 模板和报告结构。但 `/geo ...` slash commands、`~/.claude/...` 安装路径、Claude 的 `WebFetch` 工具名和 subagent 自动加载机制不能 100% 原样迁移到 Codex。

因此，Codex 使用时应把 `geo/SKILL.md` 和 `skills/geo-*/SKILL.md` 当作操作说明，根据任务选择对应脚本和文档，而不是假设它们会像 Claude Code 中一样自动注册为命令。
