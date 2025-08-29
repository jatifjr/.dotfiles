smartcat() {
  if [[ $# -eq 0 ]]; then
    command cat
    return
  fi

  local line_count
  line_count=$(command cat -- "$@" | wc -l)

  if (( line_count > LINES )); then
    command cat -- "$@" | less -RFXi
  else
    command cat -- "$@"
  fi
}
