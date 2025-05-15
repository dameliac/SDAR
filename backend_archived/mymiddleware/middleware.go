package mymiddleware

import (
	"backend/functions"
	"context"
	"log"
	"net/http"
	"strings"
)

var App *functions.App

func SetApp(app *functions.App) {
	App = app
}

// Use this function to log in the user via redis session
func LoginMiddleWare(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {

		authHeader := r.Header.Get("Authorization")
		if authHeader == "" || !strings.HasPrefix(authHeader, "Bearer ") {
			log.Println("error here")
			http.Error(w, "Unauthorized", http.StatusUnauthorized)
			return
		}

		token := strings.TrimPrefix(authHeader, "Bearer ")

		id, sessonErr := App.CheckSession(token)
		if sessonErr != nil {
			log.Println(sessonErr)
			http.Error(w, "Unauthorized", http.StatusUnauthorized)
			return
		}

		ctx := context.WithValue(r.Context(), "user_id", id)

		next.ServeHTTP(w, r.WithContext(ctx))
	})
}
