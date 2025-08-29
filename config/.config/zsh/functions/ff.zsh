ff() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: ff <file>" >&2
    return 1
  fi

  if command -v fd >/dev/null 2>&1; then
    fd -H -I "$1"
  elif command -v find >/dev/null 2>&1; then
    find . -name "*$1*" 2>/dev/null
  else
    echo "Error: neither fd nor find available" >&2
    return 1
  fi
}
