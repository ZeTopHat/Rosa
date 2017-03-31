#!/bin/bash

if [ ! -f /srv/www/htdocs/rosa/app/assets/scripts/refresh_queue.lock ]
then
  while true
  do
    cd /srv/www/htdocs/rosa
    touch /srv/www/htdocs/rosa/app/assets/scripts/refresh_queue.lock
    RAILS_ENV=production bundle exec rake refresh_queue --silent >/dev/null 2>&1
    sleep 10
  done
else
  echo "refresh_queue is already running, or lock file exists."
fi

trap "rm -f /srv/www/htdocs/rosa/app/assets/scripts/refresh_queue.lock" 15
