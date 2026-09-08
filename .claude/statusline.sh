#!/usr/bin/env bash
# Reads the JSON payload Claude Code passes on stdin
# (see https://code.claude.com/docs/en/statusline) and prints 3 lines
# of ANSI 24-bit colored blocks.
set -euo pipefail

input=$(cat)

# ---- colors: one unique gruvbox hue per chip, no repeats. No background;
# each chip's text itself is bold + colored. ----
MODEL_COLOR='251;73;52'    # bright red
EFFORT_COLOR='146;131;116' # gray
BRANCH_COLOR='69;133;136'  # blue
CHANGES_COLOR='152;151;26' # green
PR_COLOR='177;98;134'      # purple
DURATION_COLOR='214;93;14' # orange
COST_COLOR='215;153;33'    # yellow
TOKENS_COLOR='104;157;106' # aqua
CACHE_COLOR='131;165;152'  # bright blue
LINES_COLOR='211;134;155'  # bright purple
CTX_COLOR='250;189;47'     # bright yellow
FIVEH_COLOR='142;192;124'  # bright aqua
SEVEND_COLOR='254;128;25'  # bright orange

CHIPS=()
chip() {
  # chip <text> <color> - queues a chip; rendered later so it can wrap
  CHIPS+=("$1"$'\x1f'"$2")
}

# ---- session-cumulative token totals from the transcript ----
transcript_path=$(printf '%s' "$input" | jq -r '.transcript_path // empty')
token_totals="0 0 0 0"
if [[ -n "$transcript_path" && -f "$transcript_path" ]]; then
  token_totals=$(jq -s -r '
    map(select(.message.usage != null))
    | unique_by(.message.id // .uuid) as $counted
    | ($counted | map(.message.usage.input_tokens // 0) | add // 0) as $i
    | ($counted | map(.message.usage.output_tokens // 0) | add // 0) as $o
    | ($counted | map(.message.usage.cache_read_input_tokens // 0) | add // 0) as $r
    | ($counted | map(.message.usage.cache_creation_input_tokens // 0) | add // 0) as $w
    | "\($i) \($o) \($r) \($w)"
  ' "$transcript_path" 2>/dev/null || echo "0 0 0 0")
fi
read -r in_tok out_tok cache_read cache_write <<<"$token_totals"

fmt_n() {
  awk -v n="$1" 'BEGIN { if (n >= 1000) printf "%.1fk", n / 1000; else printf "%d", n }'
}

# ---- git branch + changes (cached 5s per session to stay fast) ----
session_id=$(printf '%s' "$input" | jq -r '.session_id // "nosession"')
cwd=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd')
cache_file="/tmp/claude-statusline-git-$session_id"
cache_stale=true
if [[ -f "$cache_file" ]]; then
  age=$(($(date +%s) - $(stat -f %m "$cache_file" 2>/dev/null || stat -c %Y "$cache_file" 2>/dev/null || echo 0)))
  [[ $age -le 5 ]] && cache_stale=false
fi
if $cache_stale; then
  if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
    branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
    staged=$(git -C "$cwd" diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
    modified=$(git -C "$cwd" diff --numstat 2>/dev/null | wc -l | tr -d ' ')
    untracked=$(git -C "$cwd" ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
    printf '%s|%s|%s|%s' "$branch" "$staged" "$modified" "$untracked" >"$cache_file"
  else
    printf '|||' >"$cache_file"
  fi
fi
IFS='|' read -r branch staged modified untracked <"$cache_file" || true

# ---- gather values ----
model=$(printf '%s' "$input" | jq -r '.model.display_name')
effort=$(printf '%s' "$input" | jq -r '.effort.level // empty')

lines_added=$(printf '%s' "$input" | jq -r '.cost.total_lines_added // 0')
lines_removed=$(printf '%s' "$input" | jq -r '.cost.total_lines_removed // 0')

pr_number=$(printf '%s' "$input" | jq -r '.pr.number // empty')

duration_ms=$(printf '%s' "$input" | jq -r '.cost.total_duration_ms // 0')
cost=$(printf '%s' "$input" | jq -r '.cost.total_cost_usd // 0')
mins=$((duration_ms / 60000))
secs=$(((duration_ms % 60000) / 1000))
duration_fmt="${mins}m${secs}s"
cost_fmt=$(printf '$%.2f' "$cost")

pct=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
ctx_size=$(printf '%s' "$input" | jq -r '.context_window.context_window_size // 200000')
ctx_used=$(printf '%s' "$input" | jq -r '(.context_window.total_input_tokens // 0) + (.context_window.total_output_tokens // 0)')

bar_width=10
filled=$((pct * bar_width / 100))
[[ $filled -gt $bar_width ]] && filled=$bar_width
empty=$((bar_width - filled))
bar=""
[[ $filled -gt 0 ]] && printf -v fill "%${filled}s" && bar="${fill// /▓}"
[[ $empty -gt 0 ]] && printf -v pad "%${empty}s" && bar="${bar}${pad// /░}"

five_h=$(printf '%s' "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_d=$(printf '%s' "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

# ---- queue chips in display order ----
chip "💰 $cost_fmt" "$COST_COLOR"
chip "TI: $(fmt_n "$in_tok") TO: $(fmt_n "$out_tok")" "$TOKENS_COLOR"
chip "CR: $(fmt_n "$cache_read") CW: $(fmt_n "$cache_write")" "$CACHE_COLOR"
chip "Ctx: $bar $(fmt_n "$ctx_used")/$(fmt_n "$ctx_size") (${pct}%)" "$CTX_COLOR"
chip "Model: $model" "$MODEL_COLOR"
[[ -n "$effort" ]] && chip "Effort: $effort" "$EFFORT_COLOR"
if [[ -n "$branch" ]]; then
  chip "Branch: $branch" "$BRANCH_COLOR"
  changes=""
  [[ "$staged" -gt 0 ]] && changes+="+$staged "
  [[ "$modified" -gt 0 ]] && changes+="~$modified "
  [[ "$untracked" -gt 0 ]] && changes+="?$untracked"
  [[ -n "$changes" ]] && chip "Stats: ${changes% }" "$CHANGES_COLOR"
  if [[ "$lines_added" -gt 0 || "$lines_removed" -gt 0 ]]; then
    chip "LOC: +$lines_added/-$lines_removed" "$LINES_COLOR"
  fi
fi
if [[ -n "$pr_number" ]]; then
  pr_state=$(printf '%s' "$input" | jq -r '.pr.review_state // "open"')
  chip "PR #$pr_number ($pr_state)" "$PR_COLOR"
fi
chip "⏳ $duration_fmt" "$DURATION_COLOR"
[[ -n "$five_h" ]] && chip "5h: $(printf '%.0f' "$five_h")%" "$FIVEH_COLOR"
[[ -n "$seven_d" ]] && chip "7d: $(printf '%.0f' "$seven_d")%" "$SEVEND_COLOR"

# ---- render, wrapping to new rows to fit the terminal width ----
cols="${COLUMNS:-80}"
out=""
cur_width=0
for entry in "${CHIPS[@]}"; do
  IFS=$'\x1f' read -r text color <<<"$entry"
  width=$((${#text} + 2))
  if [[ $cur_width -gt 0 && $((cur_width + width)) -gt $cols ]]; then
    out+=$'\n'
    cur_width=0
  fi
  out+=$(printf ' \033[1;38;2;%sm%s\033[0m ' "$color" "$text")
  cur_width=$((cur_width + width))
done

echo "${out}"
