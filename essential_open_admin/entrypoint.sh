#!/bin/sh
set -e

# Replace environment variables in index.html using sed
sed -i "s|__API_ORIGIN__|${API_ORIGIN}|g" /usr/share/nginx/html/index.html
sed -i "s|__VIEWER_URL__|${VIEWER_URL}|g" /usr/share/nginx/html/index.html
sed -i "s|__VIEWER_USER__|${VIEWER_USER}|g" /usr/share/nginx/html/index.html
sed -i "s|__VIEWER_PWD__|${VIEWER_PWD}|g" /usr/share/nginx/html/index.html

echo "Starting SSH ..."
service ssh start

# Execute the passed command (usually "nginx -g 'daemon off;'")
exec "$@"
