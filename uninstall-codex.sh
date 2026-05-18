#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# GEO-SEO Codex Skill Uninstaller
# Removes files installed by install-codex.sh.
# ============================================================

CODEX_HOME="${CODEX_HOME:-${HOME}/.codex}"
SKILLS_DIR="${CODEX_SKILLS_DIR:-${CODEX_HOME}/skills}"
AGENTS_DIR="${CODEX_AGENTS_DIR:-${CODEX_HOME}/agents}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

shopt -s nullglob

echo ""
echo -e "${YELLOW}GEO-SEO Codex Skill Uninstaller${NC}"
echo ""
echo "This will remove:"
[ -d "${SKILLS_DIR}/geo" ] && echo "  ${SKILLS_DIR}/geo/"
for skill_dir in "${SKILLS_DIR}"/geo-*/; do
    [ -d "$skill_dir" ] && echo "  ${skill_dir}"
done
for agent_file in "${AGENTS_DIR}"/geo-*.md; do
    [ -f "$agent_file" ] && echo "  ${agent_file}"
done
echo ""

if [ -t 0 ]; then
    read -r -p "Continue? (y/n): " reply
    if [[ ! "$reply" =~ ^[Yy]$ ]]; then
        echo "Uninstall cancelled."
        exit 0
    fi
fi

rm -rf "${SKILLS_DIR}/geo"
for skill_dir in "${SKILLS_DIR}"/geo-*/; do
    rm -rf "$skill_dir"
done
for agent_file in "${AGENTS_DIR}"/geo-*.md; do
    rm -f "$agent_file"
done

echo -e "${GREEN}GEO-SEO Codex files removed.${NC}"
echo "Prospect data in ~/.geo-prospects/ was not removed."
