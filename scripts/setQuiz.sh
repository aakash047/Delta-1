#!/bin/bash

MENTORS_DIR="/home/aakash/Desktop/Delta/Core/mentors"
MENTEES_DIR="/home/aakash/Desktop/Delta/Core/mentees"

# Function to set a quiz
set_quiz() {
  mentor_name="$1"
  shift
  mentor_domain="$1"
  shift

  for mentee_rollno in $(cat "$MENTORS_DIR/$mentor_domain/$mentor_name/allocatedMentees.txt"); do
    # Create filename for the quiz file
    quiz_file="$MENTEES_DIR/$mentee_rollno/quizquestions.txt"
    for question in "$@"; do
        echo "$question" >> "$quiz_file"
    done
  done
  echo "Quiz created by $mentor_name."
}

# Function to check for quizzes
check_for_quiz() {
  mentee_rollno="$1"

  # Check if quiz file exists for the mentee
  quiz_file="$MENTEES_DIR/$mentee_rollno/quizquestions.txt"
  if [ -f "$quiz_file" ]; then
    echo "Hi $mentee_rollno, you have a new quiz."
    echo "Quiz questions:"
    answer_file="$MENTEES_DIR/$mentee_rollno/quizanswers.txt"
    touch "$answer_file"
    mapfile -t questions < "$quiz_file"
    for question in "${questions[@]}"; do
        if [[ ! -z "$question" ]]; then
            echo "$question"
            read -p "Enter your answer: " answer
            echo "Q: $question" >> "$answer_file"  # Append question to answers file
            echo "A: $answer" >> "$answer_file"    # Append answer to answers file
            echo ""
        fi
    done 
    echo "Answers saved for $mentee_rollno."
  else
    echo "Hi $mentee_rollno, you have no new quizzes."
  fi
}

# Main script execution
current_user=$(whoami)
if [[ "$current_user" =~ ^[0-9]{8}$ ]]; then
    mentee_rollno=$current_user
    check_for_quiz "$mentee_rollno"
else
    mentor_name="$current_user"
    mentor_domain="$1"
    shift
    set_quiz "$mentor_name" "$mentor_domain" "$@"
fi
