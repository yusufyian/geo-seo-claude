#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# GEO-SEO Codex Skill Installer
# Installs this Claude-oriented GEO bundle into Codex-friendly
# local skill directories without modifying the Claude installer.
# ============================================================

CODEX_HOME="${CODEX_HOME:-${HOME}/.codex}"
SKILLS_DIR="${CODEX_SKILLS_DIR:-${CODEX_HOME}/skills}"
AGENTS_DIR="${CODEX_AGENTS_DIR:-${CODEX_HOME}/agents}"
INSTALL_DIR="${SKILLS_DIR}/geo"
VENV_DIR="${INSTALL_DIR}/.venv"
VENV_PY="${VENV_DIR}/bin/python3"
CODEX_MD_PY="${VENV_PY/#$HOME/~}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_success() { echo -e "${GREEN}[OK] $1${NC}"; }
print_warning() { echo -e "${YELLOW}[!!] $1${NC}"; }
print_error() { echo -e "${RED}[XX] $1${NC}"; }
print_info() { echo -e "${BLUE}[>>] $1${NC}"; }

sed_inplace() {
    local pattern="$1"
    local file="$2"
    sed -i.bak "$pattern" "$file" && rm -f "${file}.bak"
}

main() {
    echo ""
    echo -e "${BLUE}GEO-SEO Codex Skill Installer${NC}"
    echo ""

    if ! command -v python3 >/dev/null 2>&1; then
        print_error "Python 3.8+ is required but python3 was not found."
        exit 1
    fi
    print_success "Python found: $(python3 --version)"

    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if [ ! -f "${SCRIPT_DIR}/geo/SKILL.md" ]; then
        print_error "Run this installer from a checkout containing geo/SKILL.md."
        exit 1
    fi

    print_info "Installing skills into ${SKILLS_DIR}"
    mkdir -p "$SKILLS_DIR" "$AGENTS_DIR" "$INSTALL_DIR"
    mkdir -p "$INSTALL_DIR/scripts" "$INSTALL_DIR/schema"

    cp -R "${SCRIPT_DIR}/geo/." "$INSTALL_DIR/"

    skill_count=0
    for skill_dir in "${SCRIPT_DIR}/skills"/*/; do
        [ -d "$skill_dir" ] || continue
        skill_name="$(basename "$skill_dir")"
        mkdir -p "${SKILLS_DIR}/${skill_name}"
        cp -R "${skill_dir}/." "${SKILLS_DIR}/${skill_name}/"
        skill_count=$((skill_count + 1))
    done

    agent_count=0
    for agent_file in "${SCRIPT_DIR}/agents/"*.md; do
        [ -f "$agent_file" ] || continue
        cp "$agent_file" "$AGENTS_DIR/"
        agent_count=$((agent_count + 1))
    done

    cp -R "${SCRIPT_DIR}/scripts/." "$INSTALL_DIR/scripts/"
    cp -R "${SCRIPT_DIR}/schema/." "$INSTALL_DIR/schema/"
    cp "${SCRIPT_DIR}/requirements.txt" "$INSTALL_DIR/" 2>/dev/null || true

    print_info "Creating isolated Python environment at ${VENV_DIR}"
    rm -rf "$VENV_DIR"
    python3 -m venv "$VENV_DIR"
    "$VENV_PY" -m pip install --upgrade pip --quiet
    "$VENV_PY" -m pip install -r "${SCRIPT_DIR}/requirements.txt" --quiet

    print_info "Pinning installed scripts to the Codex venv"
    for script in "$INSTALL_DIR"/scripts/*.py; do
        [ -f "$script" ] || continue
        sed_inplace "1s|^#!.*|#!${VENV_PY}|" "$script"
        chmod +x "$script"
    done

    print_info "Rewriting Claude paths in installed Markdown files"
    for file in "$INSTALL_DIR/SKILL.md" "$SKILLS_DIR"/geo-*/SKILL.md "$AGENTS_DIR"/geo-*.md; do
        [ -f "$file" ] || continue
        sed_inplace "s|~/.claude/skills/geo/scripts|${INSTALL_DIR/#$HOME/~}/scripts|g" "$file"
        sed_inplace "s|~/.claude/skills/geo/schema|${INSTALL_DIR/#$HOME/~}/schema|g" "$file"
        sed_inplace "s|python3 -c |${CODEX_MD_PY} -c |g" "$file"
        sed_inplace "s|python3 -m |${CODEX_MD_PY} -m |g" "$file"
    done

    print_success "Main skill installed: ${INSTALL_DIR}"
    print_success "Sub-skills installed: ${skill_count}"
    print_success "Agent reference files copied: ${agent_count}"
    echo ""
    echo "Restart Codex so it can discover newly installed skills."
    echo "If your Codex setup reads skills from another directory, rerun with:"
    echo "  CODEX_SKILLS_DIR=/path/to/skills ./install-codex.sh"
    echo ""
}

main "$@"
