fkill() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: fkill <process>" >&2
    return 1
  fi

  if ! command -v pgrep >/dev/null 2>&1; then
    echo "Error: pgrep is not available on this system" >&2
    return 1
  fi

  local pids
  pids=$(pgrep -f "$1")

  if [[ -n "$pids" ]]; then
    echo "Killing: $pids"
    kill $pids
  else
    echo "No process found matching: $1" >&2
    return 1
  fi
}
