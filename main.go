package main

import (
	"backend/database"
	"context"
	"database/sql"
	"encoding/json"
	"fmt"
	"time"

	_ "github.com/go-sql-driver/mysql"
)

type Preferences struct {
	Mode     string `json:"mode"`
	PrefType string `json:"prefType"`
}

func main() {
	ctx := context.Background()

	time.Sleep(5 * time.Second)

	db, err := sql.Open("mysql", "root:my_secret_password@tcp(mysql:3306)/capstone?parseTime=true")
	if err != nil {
		// return err
	}

	queries := database.New(db)
	prefs := Preferences{
		Mode:     "dark",
		PrefType: "default",
	}

	prefsJSON, err := json.Marshal(prefs)
	if err != nil {
		// Handle error
	}
	res, err := queries.AddUser(ctx, database.AddUserParams{
		Firstname:   "John",
		Lastname:    "Bob",
		Preferences: json.RawMessage(prefsJSON),
	})

	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Println(res.RowsAffected())
	}
}
