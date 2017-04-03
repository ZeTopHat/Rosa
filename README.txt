Essential Cron Jobs:

*/7 * * * * sleep 40; /bin/bash -l -c 'cd /srv/www/htdocs/maria && bundle exec rake refresh_data --silent >/dev/null 2>&1'
*/30 * * * * /bin/bash -l -c '/srv/www/htdocs/maria/app/assets/scripts/refresh_queue.sh >/dev/null 2>&1'
*/5 * * * * sleep 60; /bin/bash -l -c 'cd /srv/www/htdocs/maria && bundle exec rake refresh_srs --silent >/dev/null 2>&1'
58 23 * * * /bin/bash -l -c 'cd /srv/www/htdocs/maria && bundle exec rake refresh_taken --silent >/dev/null 2>&1'

The first cron pulls the stats data using a rake task.
The second cron runs a bash script that then runs a rake task every 8 seconds. It uses a lock file to prevent multiple instances of the script from running.
The third cron refreshes important information on the SRs in the database that might have been changed in siebel directly since the creation of the SR in the Maria database.
The fourth cron clears the SRs Taken table once a night at 11:58 pm.

The site is daemonized through a custom Nginx Passenger build. Its file are located in /opt/nginx. The host setup is in /opt/nginx/conf/nginx.conf. To impliment a change from that file you'd run:
# systemctl daemon-reload
# systemctl stop nginx
# systemctl start nginx

A current bug is that a restart and stop of nginx show an error in the status, despite the action being successful.

The queues that Rosa show in queue are determined by the ourqueues.txt file.
The History section is pulled from the /var/log/qmonhistory.log file and filtered by queues and users monitored.

All stats are pulled from proetus rather than qmon.

To add new usernames or queues refer to the usernames.txt, and *queues.txt files respectively.

Added teaminfo.txt functionality. If the file exists and has content it will display above the SRs in queue.
