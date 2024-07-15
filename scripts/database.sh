#!/bin/bash

# Database and SQL file details
DATABASE_NAME="server_db"
SQL_FILE="/home/aakash/Desktop/Delta/shared/database.sql"
MENTEES_FILE="/home/aakash/Desktop/Delta/Core/mentees_domain.txt"
MENTEES_DIR="/home/aakash/Desktop/Delta/Core/mentees"

# Create SQL file
echo "Generating SQL commands..."
cat <<EOL > $SQL_FILE

CREATE TABLE IF NOT EXISTS mentees (
  rollno INTEGER PRIMARY KEY,
  domain1 VARCHAR(6),
  domain2 VARCHAR(6),
  domain3 VARCHAR(6)
);

CREATE TABLE IF NOT EXISTS tasks (
  task_id SERIAL PRIMARY KEY,
  rollno INTEGER,
  task_name VARCHAR(50),
  domain VARCHAR(6),
  submitted BOOLEAN DEFAULT FALSE,
  submission_date TIMESTAMP,
  completion_date TIMESTAMP,
  CONSTRAINT unique_task UNIQUE (rollno, task_name, domain),
  FOREIGN KEY (rollno) REFERENCES mentees(rollno)
);

CREATE USER pgadmin WITH PASSWORD 'pg_password';
GRANT CONNECT ON DATABASE $DATABASE_NAME TO pgadmin;
GRANT USAGE ON SCHEMA public TO pgadmin;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO pgadmin;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO pgadmin;
EOL

# Populate mentees table with initial data
echo "Populating mentees table..."
while read -r rollno domain1 domain2 domain3; do
  echo "INSERT INTO mentees (rollno, domain1, domain2, domain3) VALUES ($rollno, '$domain1', '$domain2', '$domain3') ON CONFLICT (rollno) DO NOTHING;" >> $SQL_FILE
done < "$MENTEES_FILE"

# Process task files
echo "Processing task files..."
for mentee_dir in "$MENTEES_DIR"/*; do
  rollno=$(basename "$mentee_dir")
  echo "Processing mentee: $rollno"

  # Process task_submitted.txt
  if [ -f "$mentee_dir/task_submitted.txt" ]; then
    echo "Processing task_submitted.txt for $rollno"
    while IFS=',' read -r task_info domain_info submission_info; do
      task_name=$(echo "$task_info" | cut -d':' -f2 | xargs)
      domain=$(echo "$domain_info" | cut -d':' -f2 | xargs)
      submission_date=$(echo "$submission_info" | cut -d':' -f2- | xargs)
      
      echo "Task submitted: $task_name in $domain on $submission_date"
      
      # Generate SQL command
      echo "INSERT INTO tasks (rollno, task_name, domain, submitted, submission_date) 
            VALUES ('$rollno', '$task_name', '$domain', TRUE, '$submission_date')
            ON CONFLICT (rollno, task_name, domain) 
            DO UPDATE SET submitted = TRUE, submission_date = '$submission_date';" >> $SQL_FILE
    done < "$mentee_dir/task_submitted.txt"
  else
    echo "No task_submitted.txt found for $rollno"
  fi

  # Process task_completed.txt
  if [ -f "$mentee_dir/task_completed.txt" ]; then
    echo "Processing task_completed.txt for $rollno"
    while IFS=',' read -r task_info domain_info completion_info; do
      task_name=$(echo "$task_info" | cut -d':' -f2 | xargs)
      domain=$(echo "$domain_info" | cut -d':' -f2 | xargs)
      completion_date=$(echo "$completion_info" | cut -d':' -f2- | xargs)
      
      echo "Task completed: $task_name in $domain on $completion_date"
      
      # Generate SQL command
      echo "UPDATE tasks 
            SET completed = TRUE, completion_date = '$completion_date'
            WHERE rollno = '$rollno' AND task_name = '$task_name' AND domain = '$domain';" >> $SQL_FILE
    done < "$mentee_dir/task_completed.txt"
  else
    echo "No task_completed.txt found for $rollno"
  fi
done

# Uncomment the following lines to execute the SQL commands
# echo "Executing SQL commands..."
# if psql -U postgres -d $DATABASE_NAME -f "$SQL_FILE"; then
#     echo "Database setup completed successfully."
# else
#     echo "Error: Database setup failed. Check the SQL file and permissions."
#     exit 1
# fi

echo "Database setup completed. You can now connect to the '$DATABASE_NAME' database."
