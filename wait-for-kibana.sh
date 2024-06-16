#!/bin/bash

set -e

host="$1"
shift
cmd="$@"

until curl -sSf "$host" >/dev/null; do
	echo "Kibana is unavailable - sleeping"
	sleep 10
done

echo "Kibana is up - executing command"
exec $cmd
