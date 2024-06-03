#!/bin/bash

# Base directory
BASE_DIR="/tmp/Core"
CORE_HOME="$BASE_DIR/Core"
MENTEES_DIR="$CORE_HOME/mentees"

# Function to run displayStatus
run_display_status() {
    bash /path/to/displayStatus.sh
}

# Function to check deregistration and clean up mentee data
check_deregistered_mentees() {
    # Loop through each mentee
    for mentee_home in "$MENTEES_DIR"/*; do
        if [ -d "$mentee_home" ]; then
            mentee=$(basename "$mentee_home")
            domains=$(ls "$mentee_home")
            if [ -z "$domains" ]; then
                # Mentee deregistered from all domains, remove all traces
                rm -rf "$mentee_home"
                sed -i "/^$mentee /d" "$CORE_HOME/mentees_domain.txt"
                for mentor_home in $(find "$CORE_HOME/mentors" -mindepth 1 -maxdepth 1 -type d); do
                    sed -i "/^$mentee /d" "$mentor_home/allocatedMentees.txt"
                done
                echo "Removed all traces of $mentee."
            else
                # Mentee deregistered from some domains, clean up respective mentor files
                for domain in $domains; do
                    for mentor_home in $(find "$CORE_HOME/mentors" -mindepth 1 -maxdepth 1 -type d); do
                        if grep -q "^$mentee $domain" "$mentor_home/allocatedMentees.txt"; then
                            sed -i "/^$mentee $domain/d" "$mentor_home/allocatedMentees.txt"
                            echo "Removed $mentee from $mentor_home/allocatedMentees.txt for domain $domain."
                        fi
                    done
                done
            fi
        fi
    done
}

# Run displayStatus
run_display_status

# Run check_deregistered_mentees only on specified days
if [[ "$(date +%u)" =~ ^(1|4|7)$ ]] || [[ "$(date +%m)" =~ ^(05|06|07)$ && "$(date +%u)" =~ ^(0|3|6)$ ]]; then
    check_deregistered_mentees
fi


## crontab -e

## 0 0 * * * /path/to/cronTask.sh
## 10 10 */3,7 5-7 * /path/to/cronTask.sh
