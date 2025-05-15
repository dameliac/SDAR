-- Active: 1739830206872@@127.0.0.1@3306@capstone
CREATE TABLE IF NOT EXISTS Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    password_hash VARCHAR(100) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    vehicle_type VARCHAR(100) NOT NULL,
    preferences JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)

-- INSERT INTO Users (first_name,last_name,password_has)