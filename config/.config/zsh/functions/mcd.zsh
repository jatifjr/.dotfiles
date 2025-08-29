mcd() {
  [[ $# -eq 1 ]] || {
    echo "Usage: mcd <dir>" >&2
    return 1
  }

  mkdir -p "$1" && cd "$1"
}
