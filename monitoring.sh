#!/bin/bash

PROCESS="test"
API="https://test.com/monitoring/test/api"
LOG="/var/log/monitoring.log"
PIDFILE="/var/run/test.pid"

mkdir -p "$(dirname "$LOG")" "$(dirname "$PIDFILE")"
touch "$LOG"

process_is_on() {
    local pid=$(pgrep -x "$PROCESS" 2>/dev/null)

    if [[ -n "$pid" ]]; then
        echo "$pid"
        return 0
    else
        return 1
    fi
}

if process_is_on; then
    CURRENT_PID=$(process_is_on)

    if [[ -f "$PIDFILE" ]]; then
        PREVIOUS_PID=$(cat "$PIDFILE" 2>/dev/null)

        if [[ "$CURRENT_PID" != "$PREVIOUS_PID" && -n "$PREVIOUS_PID" ]]; then
            echo "INFO:$(date '+%Y-%m-%d %H:%M:%S') - Process '$PROCESS' was restarted (PID: $PREVIOUS_PID -> $CURRENT_PID)" >> "$LOG"
        fi
    fi

    echo "$CURRENT_PID" > "$PIDFILE"

	HTTP_CODE=$(curl -s -o /dev/null -m 5 -w "%{http_code}" "$API")

	if ! [[ "$HTTP_CODE" =~ ^[23][0-9]{2}$ ]]; then
		echo "INFO:$(date '+%Y-%m-%d %H:%M:%S') - Server at $API returned HTTP $HTTP_CODE (unavailable or error)" >> "$LOG"
	fi
fi
