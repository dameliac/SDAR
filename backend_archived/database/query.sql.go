// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0
// source: query.sql

package database

import (
	"context"
	"database/sql"
	"encoding/json"
)

const createUser = `-- name: CreateUser :execresult
INSERT INTO ` + "`" + `Users` + "`" + ` (first_name, last_name, email , preferences, vehicle_type , password_hash)
VALUES (? , ? , ?, ? , ? , ?)
`

type CreateUserParams struct {
	FirstName    string
	LastName     string
	Email        string
	Preferences  json.RawMessage
	VehicleType  string
	PasswordHash string
}

func (q *Queries) CreateUser(ctx context.Context, arg CreateUserParams) (sql.Result, error) {
	return q.db.ExecContext(ctx, createUser,
		arg.FirstName,
		arg.LastName,
		arg.Email,
		arg.Preferences,
		arg.VehicleType,
		arg.PasswordHash,
	)
}

const getUser = `-- name: GetUser :one
SELECT user_id, first_name, password_hash, last_name, email, vehicle_type, preferences, created_at FROM Users
WHERE user_id = ? LIMIT 1
`

func (q *Queries) GetUser(ctx context.Context, userID int32) (User, error) {
	row := q.db.QueryRowContext(ctx, getUser, userID)
	var i User
	err := row.Scan(
		&i.UserID,
		&i.FirstName,
		&i.PasswordHash,
		&i.LastName,
		&i.Email,
		&i.VehicleType,
		&i.Preferences,
		&i.CreatedAt,
	)
	return i, err
}
