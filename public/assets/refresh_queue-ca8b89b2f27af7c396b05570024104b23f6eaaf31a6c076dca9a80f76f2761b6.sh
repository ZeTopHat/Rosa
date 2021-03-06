#!/bin/bash

# if the process is given a sigterm it will remove the lock file so that the cron can start the process back up
trap "rm -f /srv/www/htdocs/rosa/app/assets/scripts/refresh_queue.lock; exit" 15

# If the lock file exists don't start a new while loop.
if [ ! -f /srv/www/htdocs/rosa/app/assets/scripts/refresh_queue.lock ]
then
  while true
  do
    touch /srv/www/htdocs/rosa/app/assets/scripts/refresh_queue.lock
    # Execute rake task on production. This is what updates the queue of service requests in the database.
    cd /srv/www/htdocs/rosa && RAILS_ENV=production /srv/www/htdocs/rosa/bin/rake refresh_queue --silent >/dev/null 2>&1
    sleep 10
  done
else
  echo "refresh_queue is already running, or lock file exists."
fi
