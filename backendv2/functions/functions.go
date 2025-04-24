package functions

import (
	"backend/database"
	"backend/models"
	"context"
	"crypto/rand"
	"database/sql"
	"encoding/base32"
	"encoding/json"
	"errors"
	"fmt"
	"log"

	"github.com/redis/go-redis/v9"
	"golang.org/x/crypto/bcrypt"
)

type App struct {
	Queries  *database.Queries
	Database *sql.DB
	Ctx      context.Context
	Rdb      *redis.Client
}

func (app *App) Init() {
	err := app.Database.Ping()
	log.Println(err)
}

func (app *App) CheckSession(token string) (string, error) {
	sessionId := "session:" + token
	exists, err := app.Rdb.Exists(app.Ctx, sessionId).Result()
	if err != nil || exists == 0 {
		log.Println("exists no")
		return "", err
	}

	id := app.Rdb.HGet(app.Ctx, sessionId, "user_id")

	// log.Println(id.Err() == nil)

	if id.Err() != nil {
		log.Println(id.Err())
		return "", errors.New("Redis error")
	}

	return id.Val(), nil

}

func IsValidUser(user models.User) (bool, []string) {
	missingFields := []string{}

	if user.Firstname == "" {
		missingFields = append(missingFields, "firstname")
	}
	if user.LastName == "" {
		missingFields = append(missingFields, "lastname")
	}
	if user.Email == "" {
		missingFields = append(missingFields, "email")
	}
	if user.Password == "" {
		missingFields = append(missingFields, "password")
	}
	if user.VehicleType == "" {
		missingFields = append(missingFields, "vehicleType")
	}

	return len(missingFields) == 0, missingFields
}

func (app *App) saveSession(token string, user models.User, id int64) {
	sessionId := fmt.Sprintf("session:%v", token)

	preferencesJSON, err := json.Marshal(user.Preferences)
	if err != nil {
		log.Println("Error marshaling preferences:", err)
	}

	result := app.Rdb.HSet(
		app.Ctx,
		sessionId,
		"user_id", id,
		"vehicleType", user.VehicleType,
		"preferences", string(preferencesJSON),
	)

	if result.Err() != nil {
		log.Println("Error saving session:", result.Err())
	}
}

func (app *App) CreateNewUser(user models.User) (int64, string, error) {

	hashed_password, hashing_err := hashPassword(user.Password)

	if hashing_err != nil {
		return -1, "", hashing_err
	}

	preferencesJSON, err := json.Marshal(user.Preferences)
	if err != nil {
		return -1, "", err
	}

	result, result_err := app.Queries.CreateUser(app.Ctx, database.CreateUserParams{
		FirstName:    user.Firstname,
		LastName:     user.LastName,
		Email:        user.Email,
		PasswordHash: hashed_password,
		VehicleType:  user.VehicleType,
		Preferences:  preferencesJSON,
		// PasswordHash: use,
	})

	if result_err != nil {

		return -1, "", result_err
	}

	log.Println(result.LastInsertId())

	user_id, _ := result.LastInsertId()

	token := getToken()

	app.saveSession(token, user, user_id)

	return user_id, token, nil
}

func getToken() string {
	bytes := make([]byte, 80)
	rand.Read(bytes)
	sessionId := base32.StdEncoding.EncodeToString(bytes)
	return sessionId
}

func hashPassword(password string) (string, error) {
	bytes, err := bcrypt.GenerateFromPassword([]byte(password), 11)
	return string(bytes), err
}

func CheckPasswordHash(password, hash string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
	return err == nil
}
