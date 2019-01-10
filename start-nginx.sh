#!/usr/bin/with-contenv sh
set -e;

/bin/wait-for.sh -t 120 127.0.0.1:9000

mkdir -p /run/nginx
/usr/sbin/nginx

sudo service nginx status
