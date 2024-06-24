#!/bin/bash

# Base directories
CORE_HOME="/home/aakash/Desktop/Delta/Core"
MENTORS_DIR="$CORE_HOME/mentors"
MENTEES_DIR="$CORE_HOME/mentees"

# Function for mentees to submit a task
mentee_submit_task() {
    mentee_rollno=$1
    task_name=$2
    domain=$3

    # Check if mentee exists
    MENTEE_HOME="$MENTEES_DIR/$mentee_rollno"
    if [ ! -d "$MENTEE_HOME" ]; then
        echo "Mentee $mentee_rollno does not exist."
        exit 1
    fi

    # Populate task_submitted.txt
    echo "Task: $task_name, Domain: $domain, Submitted on: $(date)" >> "$MENTEE_HOME/task_submitted.txt"

    # Create task folder under the respective domain
    DOMAIN_DIR="$MENTEES_DIR/$mentee_rollno/$domain/$task_name"
    mkdir -p "$DOMAIN_DIR"

    echo "Task $task_name submitted for domain $domain."
}

# Function for mentors to create symlinks and check task completion
mentor_submit_task() {
    mentor_name=$1
    mentor_domain=$2

    # Check if mentor exists
    MENTOR_HOME="$MENTORS_DIR/$mentor_domain/$mentor_name"
    if [ ! -d "$MENTOR_HOME" ]; then
        echo "Mentor $mentor_name does not exist."
        exit 1
    fi

    # Loop through allocated mentees
    ALLOCATED_MENTEES="$MENTOR_HOME/allocatedMentees.txt"
    while read -r mentee_rollno; do
        MENTEE_HOME="$MENTEES_DIR/$mentee_rollno"
        for task_dir in "$MENTEE_HOME/$mentor_domain/"*; do
            task_name=$(basename "$task_dir")
            MENTOR_TASK_DIR="$MENTOR_HOME/submittedTasks/$task_name"

            # Create symlink if it doesn't exist
            if [ ! -L "$MENTOR_TASK_DIR/$mentee_rollno" ]; then
                ln -s "$task_dir" "$MENTOR_TASK_DIR/$mentee_rollno"
            fi

            # Check if task is completed and update task_completed.txt
            if [ "$(ls -A "$task_dir")" ]; then
                echo "Task: $task_name, Domain: $mentor_domain, Mentee: $mentee_rollno, Completed on: $(date)" >> "$MENTEE_HOME/task_completed.txt"
            fi
        done
    done < "$ALLOCATED_MENTEES"

    echo "Mentor $mentor_name processed submitted tasks."
}

# Main script execution
current_user=$(whoami)
if [[ "$current_user" =~ ^[0-9]{8}$ ]]; then
    # Mentee
    if [ $# -ne 2 ]; then
        echo "Usage: submitTask <task_name> <domain>"
        exit 1
    fi
    task_name=$1
    domain=$2
    mentee_submit_task "$current_user" "$task_name" "$domain"
else
    # Mentor
    mentor_name="$current_user"
    mentor_domain=$1
    mentor_submit_task "$mentor_name" "$mentor_domain"
fi