#!/usr/bin/env bash

echo "
Welcome to a TrueForge ContainerForge container,
You are entering the vicinity of an area adjacent to a location.
The kind of place where there might be a monster, or some kind of weird mirror.
These are just examples; it could also be something much better.
* Repository: https://github.com/trueforge-org/containerforge
* Docs: https://truecharts.org
* Bugs or feature requests should be opened in an GH issue
* Questions should be discussed in Discord
"

# Check if /pre-start.sh exists
if [ -e /pre-start.sh ]; then
    if [ -x /pre-start.sh ]; then
        echo "Info: /pre-start.sh exists, running pre-start.sh"
        bash /pre-start.sh
    else
        echo "Warning: /pre-start.sh exists but is not executable" >&2
    fi
fi

# Run main application
if [ -x /start.sh ]; then
    echo "Info: Executing /start.sh"
    exec /start.sh "$@"
elif [ -e /start.sh ]; then
    echo "Error: /start.sh exists but is not executable" >&2
    exit 1
elif [ "$#" -gt 0 ]; then
    echo "Info: Executing passed command: $*"
    exec "$@"
else
    echo "Error: No /start.sh and no command provided" >&2
    exit 1
fi
