#!/usr/bin/env sh

# Terminate already running bar instances
#killall -q polybar
pgrep polybar | xargs kill
# If all your bars have ipc enabled, you can also use
# polybar-msg cmd quit

while pgrep polybar >/dev/null; do sleep 1; done

# Launch
# echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
#polybar top 2>&1 | tee -a /tmp/polybar1.log & disown
polybar DP0 &
polybar DP4 &
#polybar bottom 2>&1 | tee -a /tmp/polybar2.log & disown

echo "Bars launched..."
