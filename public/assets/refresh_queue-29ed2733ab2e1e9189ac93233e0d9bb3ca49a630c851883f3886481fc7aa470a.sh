#!/bin/bash

# If the lock file exists don't start a new while loop.
if [ ! -f /srv/www/htdocs/rosa/app/assets/scripts/refresh_queue.lock ]
then
  while true
  do
    cd /srv/www/htdocs/rosa
    touch /srv/www/htdocs/rosa/app/assets/scripts/refresh_queue.lock
    # Execute rake task on production. This is what updates the queue of service requests in the database.
    RAILS_ENV=production bundle exec rake refresh_queue --silent >/dev/null 2>&1
    sleep 10
  done
else
  echo "refresh_queue is already running, or lock file exists."
fi

# if the process is given a sigterm it will remove the lock file so that the cron can start the process back up
trap "rm -f /srv/www/htdocs/rosa/app/assets/scripts/refresh_queue.lock" 15
