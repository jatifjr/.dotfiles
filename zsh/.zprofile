# --- Automation ---
if [[ $- == *i* ]] && [[ -z "$TMUX" ]]; then
    tmux new-session -A -s main
fi
