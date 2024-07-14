#!/bin/bash

DATABASE_NAME="server_db"
SQL_FILE="/home/aakash/Desktop/Delta/shared/database.sql"
MENTEES_FILE="/home/aakash/Desktop/Delta/Core/mentees_domain.txt"

touch $SQL_FILE

echo "USE $DATABASE_NAME;" > $SQL_FILE

echo "CREATE TABLE mentees (
  rollno INTEGER NOT NULL,
  domain1 VARCHAR(6),
  domain2 VARCHAR(6),
  domain3 VARCHAR(6)
);" >> $SQL_FILE

while read -r rollno domain1 domain2 domain3; do
  echo "INSERT INTO mentees (rollno, domain1, domain2, domain3) VALUES ($rollno, '$domain1', '$domain2', '$domain3');" >> $SQL_FILE
done < "$MENTEES_FILE"

echo "CREATE USER pg_admin WITH PASSWORD 'pg_password';
GRANT CONNECT ON DATABASE server_db TO pg_admin;
GRANT USAGE ON SCHEMA public TO pg_admin;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO pg_admin;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO readonly_user;" >> $SQL_FILE

