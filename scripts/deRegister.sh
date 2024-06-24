#!/bin/bash

# Function to deregister a mentee from specific domains
deregister() {
    local roll_number=$1
    shift
    local domains_to_remove=$@
    local mentee_home="/home/aakash/Desktop/Delta/Core/mentees/$roll_number"
    local domain_pref_file="$mentee_home/domain_pref.txt"

    echo "Roll Number: $roll_number"
    echo "Domains to Remove: ${domains_to_remove[*]}"
    echo "Mentee Home: $mentee_home"
    echo "Domain Pref File: $domain_pref_file"

    if [ ! -f "$domain_pref_file" ]; then
        echo "Domain preference file not found for roll number: $roll_number"
        return 1
    fi

    for domain in $domains_to_remove; do
        local domain_dir="$mentee_home/$domain"
        if [ -d "$domain_dir" ]; then
            rm -rf "$domain_dir"
            echo "Removed directory: $domain_dir"
        else
            echo "Domain directory $domain_dir does not exist."
        fi

        # Update the domain_pref.txt file
        sed -i "/^$domain$/d" "$domain_pref_file"
        echo "Updated domain_pref.txt for domain: $domain"
    done
    echo "Updated domain preferences for roll number: $roll_number"
}

# Main script execution
current_user=$(whoami)
if [[ ! "$current_user" =~ ^[0-9]{8,9}$ ]]; then
    echo "Only mentees can set domain preferences."
    exit 1
fi

# Call the deregister function with the provided roll number and domains
deregister "$current_user" "$@"
