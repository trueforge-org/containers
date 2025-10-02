#!/bin/bash

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

# Check if /start.sh exists
if [ -e /start.sh ]; then
    if [ -x /start.sh ]; then
        echo "Info: /start.sh exists, starting application using start.sh"
        exec /start.sh
    else
        echo "Warning: /start.sh exists but is not executable" >&2
    fi
fi

exec /start.sh "$@"
