#!/usr/bin/env bash

echo "[00-copyconfig] Copying default NGINX config files"
cp -n /defaults/nginx.conf  /etc/nginx/nginx.conf
cp -n /defaults/default.conf /config/default.conf
