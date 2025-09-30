#!/bin/bash

source /header.sh

# Check if /start.sh exists
if [ -e /start.sh ]; then
    if [ -x /start.sh ]; then
        echo "Info: /start.sh exists, starting application using start.sh"
        exec /start.sh "$@"
    else
        echo "Warning: /start.sh exists but is not executable" >&2
    fi
fi

# Execute the CMD arguments
exec "$@"
