-- Create the database for the quiz game
CREATE DATABASE IF NOT EXISTS quiz_game;

-- Use the quiz_game database
USE quiz_game;

-- Table for storing user information
CREATE TABLE IF NOT EXISTS users (
    username VARCHAR(255) PRIMARY KEY,
    password VARCHAR(255) NOT NULL
);

-- Table for storing quiz questions
CREATE TABLE IF NOT EXISTS questions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    question TEXT,
    options TEXT,
    answer TEXT,
    created_by VARCHAR(255),
    user_answer TEXT
);

-- Table for storing leaderboard information
CREATE TABLE IF NOT EXISTS leaderboard (
    username VARCHAR(255) PRIMARY KEY,
    points INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS answered_questions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255),
    question_id INT,
    FOREIGN KEY (username) REFERENCES users(username),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);



CREATE USER 'aakash'@'localhost' IDENTIFIED BY 'db_pass';
GRANT ALL PRIVILEGES ON *.* TO 'aakash'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;

