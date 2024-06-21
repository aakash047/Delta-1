#!/bin/bash

# Base directory
CORE_HOME="Core"
MENTORS_DIR="$CORE_HOME/mentors"
MENTEES_DIR="$CORE_HOME/mentees"

# Function to read mentor details
declare -A mentor_capacity
declare -A mentor_domain
read_mentors() {
    while read -r name domain capacity; do
        # echo "Reading mentor: $name, Domain: $domain, Capacity: $capacity" # Debug
        mentor_capacity["$name"]="$capacity"
        mentor_domain["$name"]="$domain"
    done < mentors.txt
}

# Function to read mentee details
declare -A mentee_domains
read_mentees() {
    while read -r roll_number domains; do
        # echo "Reading mentee: $roll_number, Domains: $domains" # Debug
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

    # Loop through mentors (FCFS)
    for mentee_roll_number in "${!mentee_domains[@]}"; do
      mentee_preferred_domains=(${mentee_domains[$mentee_roll_number]})
      for preferred_domain in "${mentee_preferred_domains[@]}"; do
        for mentor in "${!mentor_capacity[@]}"; do
          if [ "${mentor_capacity[$mentor]}" -gt 0 ]; then
            if [[ "$preferred_domain" == "${mentor_domain[$mentor]}" ]]; then
              # Allocate mentee to this mentor and update capacity
              MENTOR_HOME="$MENTORS_DIR/$preferred_domain/$mentor"
              echo "Allocating $mentee_roll_number to $mentor (before: ${mentor_capacity[$mentor]})"
              echo "$mentee_roll_number" >> "$MENTOR_HOME/allocatedMentees.txt"
              mentor_capacity["$mentor"]=$((${mentor_capacity["$mentor"]} - 1))
              echo "Capacity of $mentor (after: ${mentor_capacity[$mentor]})"
              break
            fi
          fi
        done
      done
    done

}

# Call the allocation function
allocate_mentees
