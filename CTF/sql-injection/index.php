<?php
$servername = "localhost";
$username = "root";
$password = "root"; 
$dbname = "demo_db";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $user = $_POST['username'];
    $pass = $_POST['password'];

    // Vulnerable SQL query
    $sql = "SELECT * FROM users WHERE username='$user' AND password='$pass'";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        echo "Login successful!<br>";
        echo "Hidden Flag: " . $row['hidden_flag'];
    } else {
        echo "Invalid username or password.";
    }
}

$conn->close();
?>