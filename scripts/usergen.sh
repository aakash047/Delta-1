#!/usr/bin/env bash
# Directories
CORE_HOME="/home/aakash/Desktop/Delta/Core"
MENTORS_DIR="$CORE_HOME/mentors"
MENTEES_DIR="$CORE_HOME/mentees"

# Create Core user and home directories if they don't exist
if ! id -u Core >/dev/null 2>&1; then
    useradd -m -d $CORE_HOME Core
fi
mkdir -p "${MENTORS_DIR}" "${MENTEES_DIR}"

# Create the mentees_domain.txt file with appropriate permissions
touch $CORE_HOME/mentees_domain.txt
chmod 222 $CORE_HOME/mentees_domain.txt  # Only write permissions for mentees
groupadd mentors
groupadd mentees

# Read mentor details and create directories
declare -a mentor_capacity
while read -r name domain capacity; do
    MENTOR_HOME="${MENTORS_DIR}/${domain}/${name}"
    if ! id -u $name >/dev/null 2>&1; then
        useradd -m -d $MENTOR_HOME -G mentors $name
    fi
    
    mkdir -p "${MENTOR_HOME}/submittedTasks/task1" "${MENTOR_HOME}/submittedTasks/task2" "${MENTOR_HOME}/submittedTasks/task3"
    touch "${MENTOR_HOME}/allocatedMentees.txt"
    chown -R "${name}:${name}" ${MENTOR_HOME}
    
done < mentors.txt

# Read mentee details and create directories
while read -r mentee_name mentee_rollno; do
    MENTEE_HOME="$MENTEES_DIR/$mentee_rollno"
    mkdir -p $MENTEE_HOME
    if ! id -u $mentee_rollno >/dev/null 2>&1; then
        useradd --badname -m -d $MENTEE_HOME -G mentees $mentee_rollno
    fi
    cd $MENTEE_HOME
    touch domain_pref.txt task_completed.txt task_submitted.txt
    chmod 763 "$MENTEE_HOME"
    chown -R "${mentee_rollno}:${mentee_rollno}" ${MENTEE_HOME}
done < mentees.txt


# Set permissions for Core to access all directories
setfacl -R -m u:Core:rwx $MENTORS_DIR $MENTEES_DIR

for mentor_home in $(find $MENTORS_DIR -mindepth 2 -maxdepth 2 -type d); do
    chmod 765 $mentor_home    
done

for mentee_home in $(find $MENTEES_DIR -mindepth 1 -maxdepth 1 -type d); do
    chmod 765 $mentee_home
    setfacl -m u:${mentee_home##*/}:w $CORE_HOME/mentees_domain.txt
    setfacl -m g:mentors:rwx $mentee_home
done