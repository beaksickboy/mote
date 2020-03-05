docker-compose exec -T db mongodump --archive --gzip --db mydb > dump.gz

docker-compose exec -T db mongorestore --archive --gzip < dump.gz