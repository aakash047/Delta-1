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

-- Sample data can be inserted here if needed for testing
