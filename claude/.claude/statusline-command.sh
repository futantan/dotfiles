#!/usr/bin/env bash
# Claude Code status line
# Shows: current directory | model | context usage | rate limits with reset time

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
week_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

# Shorten home directory to ~
home="$HOME"
if [ -n "$cwd" ]; then
  short_cwd="${cwd/#$home/\~}"
else
  short_cwd="$(pwd)"
  short_cwd="${short_cwd/#$home/\~}"
fi

# Format seconds-until-reset into "Xh Ym" or "Zm" string
format_reset() {
  local resets_at="$1"
  if [ -z "$resets_at" ]; then return; fi
  local now
  now=$(date +%s)
  local secs=$(( resets_at - now ))
  if [ "$secs" -le 0 ]; then
    echo "now"
    return
  fi
  local h=$(( secs / 3600 ))
  local m=$(( (secs % 3600) / 60 ))
  if [ "$h" -gt 0 ]; then
    echo "${h}h ${m}m"
  else
    echo "${m}m"
  fi
}

# Pick color based on usage percentage
usage_color() {
  local pct="$1"
  local pct_int
  pct_int=$(printf '%.0f' "$pct")
  if [ "$pct_int" -ge 80 ]; then
    echo '\033[31m'   # red
  elif [ "$pct_int" -ge 50 ]; then
    echo '\033[33m'   # yellow
  else
    echo '\033[32m'   # green
  fi
}

parts=()

# Model
if [ -n "$model" ]; then
  parts+=("$(printf '\033[33m%s\033[0m' "$model")")
fi

# Context usage
if [ -n "$used_pct" ]; then
  used_int=$(printf '%.0f' "$used_pct")
  color=$(usage_color "$used_pct")
  parts+=("$(printf "${color}ctx:%s%%\033[0m" "$used_int")")
fi

# 5-hour rate limit
if [ -n "$five_pct" ]; then
  five_int=$(printf '%.0f' "$five_pct")
  color=$(usage_color "$five_pct")
  reset_str=$(format_reset "$five_reset")
  if [ -n "$reset_str" ]; then
    parts+=("$(printf "${color}5h:%s%% (resets %s)\033[0m" "$five_int" "$reset_str")")
  else
    parts+=("$(printf "${color}5h:%s%%\033[0m" "$five_int")")
  fi
fi

# 7-day rate limit
if [ -n "$week_pct" ]; then
  week_int=$(printf '%.0f' "$week_pct")
  color=$(usage_color "$week_pct")
  reset_str=$(format_reset "$week_reset")
  if [ -n "$reset_str" ]; then
    parts+=("$(printf "${color}7d:%s%% (resets %s)\033[0m" "$week_int" "$reset_str")")
  else
    parts+=("$(printf "${color}7d:%s%%\033[0m" "$week_int")")
  fi
fi

# Join parts with separator
sep=" $(printf '\033[90m|\033[0m') "
result=""
for part in "${parts[@]}"; do
  if [ -z "$result" ]; then
    result="$part"
  else
    result="$result$sep$part"
  fi
done

printf '%s' "$result"
