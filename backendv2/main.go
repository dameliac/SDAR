package main

import (
	"backend/database"
	"backend/functions"
	"context"
	"database/sql"
	"fmt"
	"log"
	"os"

	"net/http"
	"time"

	"backend/routes"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/go-chi/httprate"

	_ "github.com/go-sql-driver/mysql"
	"github.com/joho/godotenv"
)

func main() {
	ctx := context.Background()
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}

	user := os.Getenv("MYSQL_USER")
	pass := os.Getenv("MYSQL_PASSWORD")

	connection_url := fmt.Sprintf("%v:%v@/capstone?parseTime=true", user, pass)

	db, err := sql.Open("mysql", connection_url)
	if err != nil {
		log.Fatal(err)
	}

	queries := database.New(db)

	app := &functions.App{
		Queries:  queries,
		Database: db,
		Ctx:      ctx,
	}

	app.Init()
	routes.SetApp(app)

	r := chi.NewRouter()
	r.Use(middleware.Logger)

	// err := godotenv.Load()
	// if err != nil {
	// 	log.Fatal("Error loading .env file")
	// }

	// data := os.Getenv("GOOGLE_MAPS_API_KEY")

	// log.Println(data)

	r.Get("/", routes.Hello)
	r.Post("/route", routes.GetRoute)
	// r.Post("/login", routes.Login)

	//Public routes
	r.Group(func(r chi.Router) {
		r.Use(httprate.LimitByIP(10, 1*time.Minute))
		r.Post("/signup", routes.CreateNewUser)
	})

	http.ListenAndServe(":3000", r)
}
