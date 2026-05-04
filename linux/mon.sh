#!/usr/bin/env bash
set -euo pipefail

SESSION="monitor"

if tmux has-session -t "$SESSION" 2>/dev/null; then
    exec tmux attach -t "$SESSION"
fi

tmux new-session -d -s "$SESSION" -n main

# Start with 3 extra panes = 4 total
tmux split-window -h -t "$SESSION":main.1
# tmux split-window -v -t "$SESSION":main.2
tmux split-window -v -t "$SESSION":main.1

# Arrange so pane 0 is the large left "main" pane,
# and panes 1/2/3 stack on the right
# tmux select-layout -t "$SESSION":main main-vertical

# Move one pane from right stack down to become a bottom strip under htop
# tmux break-pane -t "$SESSION":main.4
# tmux join-pane -v -t "$SESSION":main.1

# Resize to taste
tmux resize-pane -t "$SESSION":main.1 -x 150 # htop width
# tmux resize-pane -t "$SESSION":main.3 -y 12  # cpu MHz height
# tmux resize-pane -t "$SESSION":main.4 -y 18  # sensors height

# Commands
tmux send-keys -t "$SESSION":main.1 'htop' C-m
# tmux send-keys -t "$SESSION":main.3 'watch -n 1 "grep -E '\''^cpu MHz'\'' /proc/cpuinfo"' C-m
tmux send-keys -t "$SESSION":main.2 'nvtop' C-m
tmux send-keys -t "$SESSION":main.3 'watch sensors' C-m

# Titles
tmux select-pane -t "$SESSION":main.1 -T htop
# tmux select-pane -t "$SESSION":main.2 -T cpu-mhz
tmux select-pane -t "$SESSION":main.2 -T nvtop
tmux select-pane -t "$SESSION":main.3 -T sensors

tmux select-pane -t "$SESSION":main.1
exec tmux attach -t "$SESSION"
