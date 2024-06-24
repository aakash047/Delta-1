#!/bin/bash

# Base directory
BASE_DIR="/home/aakash/Desktop/Delta"
CORE_HOME="$BASE_DIR/Core"
MENTEES_DIR="$CORE_HOME/mentees"
MENTORS_DIR="$CORE_HOME/mentors"
DOMAINS=("web" "app" "sysad")

# Function to run displayStatus
run_display_status() {
  bash "$BASE_DIR/displayStatus.sh"
}

# Function to check deregistration and clean up mentee data
check_deregistered_mentees() {
  for mentee_home in "$MENTEES_DIR"/*; do
    if [ -d "$mentee_home" ]; then
      mentee=$(basename "$mentee_home")
      deregistered_from_all=true

      for domain in "${DOMAINS[@]}"; do
        if [ -d "$mentee_home/$domain" ]; then
          deregistered_from_all=false
          break
        fi
      done

      if $deregistered_from_all; then
        # Mentee deregistered from all domains, remove all traces
        rm -rf "$mentee_home"
        grep -v "^$mentee " "$CORE_HOME/mentees_domain.txt" > "$CORE_HOME/mentees_domain.txt.tmp" && mv "$CORE_HOME/mentees_domain.txt.tmp" "$CORE_HOME/mentees_domain.txt"
        for domain in "${DOMAINS[@]}"; do
            for mentor_home in "$MENTORS_DIR/$domain"/*; do
                grep -v "^$mentee " "$mentor_home/allocatedMentees.txt" > "$mentor_home/allocatedMentees.txt.tmp" && mv "$mentor_home/allocatedMentees.txt.tmp" "$mentor_home/allocatedMentees.txt"
            done
        done
        echo "Removed all traces of $mentee."
      else
        # Mentee deregistered from some domains, clean up respective mentor files
        for domain in "${DOMAINS[@]}"; do
          if [ ! -d "$mentee_home/$domain" ]; then
            for mentor_home in "$MENTORS_DIR/$domain"/*; do
              grep -v "^$mentee " "$mentor_home/allocatedMentees.txt" > "$mentor_home/allocatedMentees.txt.tmp" && mv "$mentor_home/allocatedMentees.txt.tmp" "$mentor_home/allocatedMentees.txt"
              echo "Removed $mentee from $mentor_home/allocatedMtees.txt for domain $domain."
            done
          fi
        done
      fi
    fi
  done
}

# Run displayStatus every day (no need for loop, script runs once a day)
run_display_status

# Check deregistered mentees at 10:10 on specified days (cron handles scheduling)
if [[ "$(date +%H%M)" == "1010" && ( "$(date +%m)" =~ ^(05|06|07)$ || ("$(date +%u)" =~ ^(1|4|7)$ && "$(date +%u)" =~ ^(0|3|6)$) ) ]]; then
  check_deregistered_mentees
fi


# crontab -e
# 10 10 * * * /bin/bash ./cronjob.sh
