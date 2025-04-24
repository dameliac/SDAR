package main

import (
	"log"
	"os"

	"github.com/pocketbase/pocketbase"
	"github.com/pocketbase/pocketbase/apis"
	"github.com/pocketbase/pocketbase/core"
)

func main() {
	app := pocketbase.New()

	app.OnServe().BindFunc(func(se *core.ServeEvent) error {
		// serves static files from the provided public dir (if exists)
		se.Router.GET("/{path...}", apis.Static(os.DirFS("./pb_public"), false))

		se.Router.GET("/hello", func(e *core.RequestEvent) error {
			return e.JSON(200, map[string]interface{}{"name": 1, "hello": "world"})
		})

		se.Router.GET("/hello-world", func(e *core.RequestEvent) error {
			return e.String(200, "Hello World")
		})

		return se.Next()
	})

	if err := app.Start(); err != nil {
		log.Fatal(err)
	}
}
