CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    hidden_flag VARCHAR(255)
);

INSERT INTO users (username, password, hidden_flag) VALUES ('admin', 'password123', 'FLAG{this_is_a_hidden_flag}');
INSERT INTO users (username, password, hidden_flag) VALUES ('user', 'password', NULL);
