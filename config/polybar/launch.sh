#!/usr/bin/env sh

# Terminate already running bar instances
pgrep polybar | xargs kill

while pgrep polybar >/dev/null; do sleep 1; done

polybar DP4 &
polybar DP0 &

echo "Polybar launched..."
