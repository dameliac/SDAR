-- name: GetUser :one
SELECT * FROM Users
WHERE user_id = ? LIMIT 1;

-- name: CreateUser :execresult
INSERT INTO `Users` (first_name, last_name, email , preferences, password_hash)
VALUES (? , ? , ?, ? , ?);