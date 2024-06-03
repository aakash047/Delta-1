#!/usr/bin/env bash

# Base directory
BASE_DIR="/home/aakash/Desktop/Delta"
CORE_HOME="$BASE_DIR/Core"
MENTEES_DIR="$CORE_HOME/mentees"

# Function to handle domain preference
domain_pref() {
    mentee_name=$1
    domain_pref_file="$MENTEES_DIR/$mentee_name/domain_pref.txt"
    # echo "$MENTEES_DIR/$mentee_name"

    # # Check if mentee exists
    # if [ ! -d "$MENTEES_DIR/$mentee_name" ]; then
    #     echo "Mentee $mentee_name does not exist."
    #     exit 1
    # fi

    # Get domain preferences from mentee
    echo "Enter your domain preferences (1-3) in preferred order (e.g., webdev, appdev, sysad):"
    read -p "Preference 1: " pref1
    read -p "Preference 2: " pref2
    read -p "Preference 3: " pref3


    # Write domain preferences to mentee's domain_pref.txt
    echo "1. $pref1" > "$domain_pref_file"
    echo "2. $pref2" >> "$domain_pref_file"
    echo "3. $pref3" >> "$domain_pref_file"

    # Append mentee's roll number and domains to mentees_domain.txt
    echo "$mentee_name $pref1 $pref2 $pref3" >> "$CORE_HOME/mentees_domain.txt"

    # Create directories for each chosen domain
    mkdir -p "$MENTEES_DIR/$mentee_name/$pref1"
    mkdir -p "$MENTEES_DIR/$mentee_name/$pref2"
    mkdir -p "$MENTEES_DIR/$mentee_name/$pref3"

    echo "Domain preferences set for mentee $mentee_name."
}

# Main script execution
current_user=$(whoami)
if [[ ! "$current_user" =~ ^[0-9]{8,9}$ ]]; then
    echo "Only mentees can set domain preferences."
    exit 1
fi

domain_pref "$current_user"
