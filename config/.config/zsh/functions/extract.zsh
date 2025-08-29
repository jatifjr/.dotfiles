extract() {
  if [[ $# -ne 1 || ! -f $1 ]]; then
    echo "Usage: extract <archive>" >&2
    return 1
  fi

  local file=$1
  case "${file:l}" in
    *.tar.bz2|*.tbz2)  tar xjf "$file" ;;
    *.tar.gz|*.tgz)    tar xzf "$file" ;;
    *.tar.xz|*.txz)    tar xJf "$file" ;;
    *.tar.zst)         command -v zstd >/dev/null 2>&1 && tar --zstd -xf "$file" || echo "zstd not installed" ;;
    *.tar)             tar xf "$file" ;;
    *.bz2)             bunzip2 "$file" ;;
    *.gz)              gunzip "$file" ;;
    *.rar)             command -v unrar >/dev/null 2>&1 && unrar x "$file" || echo "unrar not installed" ;;
    *.zip)             command -v unzip >/dev/null 2>&1 && unzip "$file" || echo "unzip not installed" ;;
    *.Z)               uncompress "$file" ;;
    *.7z)              command -v 7z >/dev/null 2>&1 && 7z x "$file" || echo "7z not installed" ;;
    *) echo "Unsupported archive type: $file" >&2; return 1 ;;
  esac
}
