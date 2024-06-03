#!/bin/bash

# Base directory
CORE_HOME="Core"
MENTORS_DIR="$CORE_HOME/mentors"
MENTEES_DIR="$CORE_HOME/mentees"

# Function to read mentor details
read_mentors() {
  while read -r name domain capacity; do
    mentor_capacity["$name"]="$capacity"
    mentor_domain["$name"]="$domain"
  done < mentors.txt
}

# Function to read mentee details
read_mentees() {
  while read -r roll_number domains; do
    for domain in $domains; do
      mentee_domains["$roll_number"]+="$domain "
    done
  done < "$CORE_HOME/mentees_domain.txt"
}

# Function to allocate mentees to mentors (FCFS)
allocate_mentees() {
  # Read mentor and mentee data
  read_mentors
  read_mentees

  # Process mentees in order
  for mentee_roll_number in "${!mentee_domains[@]}"; do
    # Extract mentee's domains
    mentee_preferred_domains=(${mentee_domains[$mentee_roll_number]})

    # Loop through mentors (FCFS)
    for mentor in "${!mentor_capacity[@]}"; do
      # Check if mentor has capacity and domain match
      if [ "${mentor_capacity[$mentor]}" -gt 0 ]; then
        for preferred_domain in "${mentee_preferred_domains[@]}"; do
          if [[ "$preferred_domain" == "${mentor_domain[$mentor]}" ]]; then
            # Allocate mentee to this mentor and update capacity
            MENTOR_HOME="$MENTORS_DIR/$mentor"
            echo "$mentee_roll_number" >> "$MENTOR_HOME/allocatedMentees.txt"
            mentor_capacity["$mentor"]=$((mentor_capacity["$mentor"] - 1))
            allocated=true
            break 2  # Break both inner and outer loops (allocation done)
          fi
        done
      fi
    done

    unset allocated  # Reset flag for next mentee
  done
}

# Call the allocation function
allocate_mentees
