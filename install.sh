#!/usr/bin/env bash
# Installs the meme-joker skill for OpenCode.
#
#   ./install.sh                  # English skill, global
#   ./install.sh --lang ru        # Russian skill
#   ./install.sh --lang all       # all three
#   ./install.sh --lang ru --always  # also wire it into global instructions

set -euo pipefail

LANG_CODE="en"
ALWAYS=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --lang|-l) LANG_CODE="${2:-}"; shift 2 ;;
    --always|-a) ALWAYS=1; shift ;;
    --help|-h)
      sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//'
      exit 0 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"
SKILLS_DIR="$CONFIG_DIR/skills"
INSTR_DIR="$CONFIG_DIR/instructions"

name_for() {
  case "$1" in
    en) echo "meme-joker" ;;
    ru) echo "meme-joker-ru" ;;
    lt) echo "meme-joker-lt" ;;
    *)  echo "" ;;
  esac
}

if [[ "$LANG_CODE" == "all" ]]; then
  TARGETS=(meme-joker meme-joker-ru meme-joker-lt)
else
  ONE="$(name_for "$LANG_CODE")"
  if [[ -z "$ONE" ]]; then
    echo "Unknown language: $LANG_CODE (use en, ru, lt or all)" >&2
    exit 1
  fi
  TARGETS=("$ONE")
fi

echo
echo "  meme-joker :: installing"
echo

mkdir -p "$SKILLS_DIR"

for name in "${TARGETS[@]}"; do
  src="$ROOT/skills/$name"
  [[ -d "$src" ]] || { echo "Skill folder not found: $src" >&2; exit 1; }
  rm -rf "$SKILLS_DIR/$name"
  cp -R "$src" "$SKILLS_DIR/"
  echo "  [ok] $name"
done

if [[ "$ALWAYS" -ne 1 ]]; then
  echo
  echo "  Installed. Load it with @meme-joker or just ask to \"be funny\"."
  echo "  Want it always on? Re-run with --always."
  echo
  exit 0
fi

# --- always-on wiring -------------------------------------------------------

mkdir -p "$INSTR_DIR"
if [[ -f "$ROOT/instructions/meme-joker.md" ]]; then
  cp "$ROOT/instructions/meme-joker.md" "$INSTR_DIR/meme-joker.md"
  echo "  [ok] instructions/meme-joker.md"
else
  echo "  [skip] instructions/meme-joker.md not found in repo"
fi

CONFIG_FILE=""
for candidate in "$CONFIG_DIR/opencode.jsonc" "$CONFIG_DIR/opencode.json"; do
  if [[ -f "$candidate" ]]; then CONFIG_FILE="$candidate"; break; fi
done

ENTRY='  "instructions": ["~/.config/opencode/instructions/meme-joker.md"],'

if [[ -z "$CONFIG_FILE" ]]; then
  echo
  echo "  No global opencode.json found. Add this manually:"
  echo "    \"instructions\": [\"~/.config/opencode/instructions/meme-joker.md\"]"
  echo
  exit 0
fi

if grep -q '"instructions"[[:space:]]*:' "$CONFIG_FILE"; then
  echo "  [skip] config already has \"instructions\" — add the path yourself:"
  echo "    ~/.config/opencode/instructions/meme-joker.md"
  echo
  exit 0
fi

if ! grep -qE '^[[:space:]]*"\$schema"[[:space:]]*:' "$CONFIG_FILE"; then
  echo "  [skip] could not find \"\$schema\" to anchor the edit. Add manually:"
  echo "    $ENTRY"
  echo
  exit 0
fi

BACKUP="$CONFIG_FILE.bak-meme-joker"
cp "$CONFIG_FILE" "$BACKUP"

awk -v entry="$ENTRY" '
  !done && match($0, /^[[:space:]]*"\$schema"[[:space:]]*:[[:space:]]*"[^"]*"[[:space:]]*,?[[:space:]]*$/) {
    line = $0
    sub(/[[:space:]]*,?[[:space:]]*$/, "", line)
    print line ","
    print entry
    done = 1
    next
  }
  { print }
' "$BACKUP" > "$CONFIG_FILE"

if command -v python3 >/dev/null 2>&1; then
  if python3 -c "import json,sys; json.load(open(sys.argv[1]))" "$CONFIG_FILE" 2>/dev/null; then
    echo "  [ok] instructions wired into $CONFIG_FILE"
    echo "  backup: $BACKUP"
  else
    cp "$BACKUP" "$CONFIG_FILE"
    echo "  [warn] config did not parse after the edit — reverted." >&2
    echo "  Add this line manually:" >&2
    echo "    $ENTRY" >&2
  fi
else
  echo "  [ok] instructions wired into $CONFIG_FILE (python3 not found, JSON not verified)"
  echo "  backup: $BACKUP"
fi

echo
echo "  Done. Go say something unhinged to your terminal."
echo
