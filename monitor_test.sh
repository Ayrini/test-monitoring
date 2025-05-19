#!/bin/bash

PROCESS_NAME="test"
MONITORING_URL="https://test.com/monitoring/test/api"
LOG_FILE="/var/log/monitoring.log"
STATE_FILE="/var/run/${PROCESS_NAME}_pid"

current_pid=$(pgrep -xo "$PROCESS_NAME")

if [[ -z "$current_pid" ]]; then
    exit 0
fi

if [[ -f "$STATE_FILE" ]]; then
    last_pid=$(cat "$STATE_FILE")
else
    last_pid=""
fi

if [[ "$current_pid" != "$last_pid" ]]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') Process '$PROCESS_NAME' restarted (old PID: $last_pid, new PID: $current_pid)" >> "$LOG_FILE"
fi

echo "$current_pid" > "$STATE_FILE"

curl -s --connect-timeout 5 --max-time 10 -o /dev/null -w "%{http_code}" "$MONITORING_URL" | grep -q "^2" || {
    echo "$(date '+%Y-%m-%d %H:%M:%S') Monitoring server unreachable at $MONITORING_URL" >> "$LOG_FILE"
}
