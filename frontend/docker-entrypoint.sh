#!/bin/sh
set -e
 
echo "Injecting runtime environment variables..."
 
# Replace the build-time placeholder with the actual runtime value
# Requires the Dockerfile to bake in REACT_APP_BASE_URL=__REACT_APP_BASE_URL__
find /usr/share/nginx/html/static/js -name '*.js' | xargs sed -i \
  "s|__REACT_APP_BASE_URL__|${REACT_APP_BASE_URL}|g"
 
echo "REACT_APP_BASE_URL set to: ${REACT_APP_BASE_URL}"
 
exec nginx -g 'daemon off;'
 