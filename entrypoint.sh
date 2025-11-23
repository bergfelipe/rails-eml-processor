#!/bin/bash
set -e

# Remove o PID antigo
rm -f /app/tmp/pids/server.pid

exec "$@"
