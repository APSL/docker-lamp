#!/bin/sh

echo "--> lamp start.sh script running..."

run-parts -v  --report /etc/start.d

echo "---> Starting circus..."
exec /usr/local/bin/circusd /etc/circus.ini
