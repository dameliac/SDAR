package routes

import (
	"backend/functions"
	"backend/models"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
)

var App *functions.App

func SetApp(app *functions.App) {
	App = app
}

func Hello(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("Hello World"))
}

func GetRoute(w http.ResponseWriter, r *http.Request) {
	bodyBytes, err := io.ReadAll(r.Body)
	if err != nil {
		log.Println("Error reading body:", err)
		http.Error(w, "Failed to read request body", http.StatusBadRequest)
		return
	}
	defer r.Body.Close()

	// hash, err := functions.HashPassword("hello world")
	s := functions.CheckPasswordHash("hello world", "$2a$14$lz5PlvPiJnrupFnnipXZkOi58Dh5262youR68QjEgTULJZ3rmDbya")

	data := make(map[string]interface{})
	// data["pass"] = hash
	data["true"] = s
	json.Unmarshal(bodyBytes, &data)
	encoder := json.NewEncoder(w)
	err = encoder.Encode(data)

	if err != nil {
		http.Error(w, "Internal Server Error", http.StatusInternalServerError)
		return
	}

}

func checkErrors(errors ...error) error {
	for _, err := range errors {
		if err != nil {
			return err
		}
	}
	return nil
}

// checks hashed password and generates a session with token
// func Login(w http.ResponseWriter, r *http.Request) {
// 	body, readErr := io.ReadAll(r.Body)
// 	defer r.Body.Close()

// 	type dataStruct struct {
// 		Password string
// 	}

// 	data := dataStruct{}

// 	marshalErr := json.Unmarshal(body, &data)

// 	err := checkErrors(readErr, marshalErr)
// 	if err != nil {
// 		log.Fatal(err)
// 		http.Error(w, "Bad Request", http.StatusBadRequest)
// 		return
// 	}

// 	pass := data.Password

// 	if pass != "" {
// 		// hash, _ := functions.HashPassword(pass)
// 		// sessionId := functions.GetToken()
// 		encoder := json.NewEncoder(w)
// 		response := make(map[string]any)
// 		response["token"] = sessionId

// 		w.Header().Add("content-type", "application/json")
// 		encoder.Encode(response)

// 	} else {
// 		http.Error(w, "Internal Error", http.StatusInternalServerError)
// 	}

// }

/*
	This function accepts

*
*/
func CreateNewUser(w http.ResponseWriter, r *http.Request) {

	createBody, bodyErr := io.ReadAll(r.Body)
	encoder := json.NewEncoder(w)

	defer r.Body.Close()

	if bodyErr != nil {
		log.Println(bodyErr)
		http.Error(w, fmt.Sprintf("%v", bodyErr), http.StatusBadRequest)
		return
	}

	data := models.User{}

	parseErr := json.Unmarshal(createBody, &data)

	if parseErr != nil {
		log.Println(parseErr)
		http.Error(w, fmt.Sprintf("%v", parseErr), http.StatusBadRequest)
		return
	}

	// log.Println(data.VehicleType)

	isValid, missingValues := functions.IsValidUser(data)
	if !isValid {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusBadRequest)
		encoder.Encode(
			map[string]any{
				"status":         "error",
				"message":        "Validation failed",
				"missing_fields": missingValues,
			},
		)
		return
	}

	user_id, token, err := App.CreateNewUser(data)
	if err != nil {
		log.Println(err)
		http.Error(w, fmt.Sprintf("%v", err), http.StatusInternalServerError)
		return
	}

	response := map[string]any{
		"status":       "success",
		"access_token": token,
		"user": map[string]any{
			"id":           user_id,
			"email":        data.Email,
			"firstName":    data.Firstname,
			"lastname":     data.LastName,
			"vehicle_type": data.VehicleType,
			"preferences":  data.Preferences,
		},
	}

	//TODO , save in a session

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)

	encoder.Encode(response)
	// log.Println(data)

}

func TestSession(w http.ResponseWriter, r *http.Request) {
	val := r.Context().Value("user_id")

	log.Println(val)
}
