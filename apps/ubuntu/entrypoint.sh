#!/bin/bash

source /header.sh

# Execute the CMD arguments
exec "$@"

# Check if /start.sh exists
if [ -e /pre-start.sh ]; then
    if [ -x /pre-start.sh ]; then
        echo "Info: /start.sh exists, starting application using start.sh"
        exec /start.sh
    else
        echo "Warning: /start.sh exists but is not executable" >&2
    fi
fi

# Check if /start.sh exists
if [ -e /start.sh ]; then
    if [ -x /start.sh ]; then
        echo "Info: /start.sh exists, starting application using start.sh"
        exec /start.sh
    else
        echo "Warning: /start.sh exists but is not executable" >&2
    fi
fi

# Check if /start.sh exists
if [ -e /post-start.sh ]; then
    if [ -x /post-start.sh ]; then
        echo "Info: /start.sh exists, starting application using start.sh"
        exec /start.sh "$@"
    else
        echo "Warning: /start.sh exists but is not executable" >&2
    fi
fi

