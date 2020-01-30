#! /bin/sh


until mysql --host $DB_HOST -u$DB_USERNAME -p$DB_PASSWORD --port $DB_PORT; do
 echo 'Waiting for MySQL...'
 sleep 1
done

echo "MySQL is up and running"