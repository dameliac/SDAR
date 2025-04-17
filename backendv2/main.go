package main

import (
	"backend/database"
	"backend/functions"
	"backend/mymiddleware"
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
	"github.com/redis/go-redis/v9"
)

func main() {
	ctx := context.Background()
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}

	rdb := redis.NewClient(&redis.Options{
		Addr:     "localhost:6379",
		Password: "", // no password set
		DB:       0,  // use default DB
	})

	val, err := rdb.Get(ctx, "name").Result()
	fmt.Println(val)

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
		Rdb:      rdb,
	}

	app.Init()
	routes.SetApp(app)
	mymiddleware.SetApp(app)

	r := chi.NewRouter()

	r.Get("/", routes.Hello)
	r.Post("/route", routes.GetRoute)
	// r.Post("/login", routes.Login)

	//Private Routes
	r.Group(func(r chi.Router) {
		r.Use(middleware.Logger)
		r.Use(mymiddleware.LoginMiddleWare)
		r.Get("/test", routes.TestSession)
	})

	//Public Routes
	r.Group(func(r chi.Router) {
		r.Use(httprate.LimitByIP(10, 1*time.Minute))
		r.Post("/signup", routes.CreateNewUser)
	})

	http.ListenAndServe(":3000", r)
}
