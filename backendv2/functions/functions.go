package functions

import (
	"backend/database"
	"backend/models"
	"context"
	"crypto/rand"
	"database/sql"
	"encoding/base32"
	"log"

	"golang.org/x/crypto/bcrypt"
)

type App struct {
	Queries  *database.Queries
	Database *sql.DB
	Ctx      context.Context
}

func (app *App) Init() {
	err := app.Database.Ping()
	log.Println(err)
}

func (app *App) CreateNewUser(user models.User) (string, error) {

	hashed_password, hashing_err := hashPassword(user.Password)

	if hashing_err != nil {
		log.Println("oops")
		return "", hashing_err
	}

	result, result_err := app.Queries.CreateUser(app.Ctx, database.CreateUserParams{
		FirstName:    user.Firstname,
		LastName:     user.LastName,
		Email:        user.Email,
		PasswordHash: hashed_password,
		// Preferences: json.RawMessage{},
		// PasswordHash: use,
	})

	if result_err != nil {

		log.Println("here")
		return "", result_err
	}

	log.Println(result)

	token := getToken()

	return token, nil
}

func getToken() string {
	bytes := make([]byte, 112)
	rand.Read(bytes)
	sessionId := base32.StdEncoding.EncodeToString(bytes)
	return sessionId
}

func hashPassword(password string) (string, error) {
	bytes, err := bcrypt.GenerateFromPassword([]byte(password), 14)
	return string(bytes), err
}

func CheckPasswordHash(password, hash string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
	return err == nil
}
