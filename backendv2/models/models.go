package models

// User struct
type User struct {
	Firstname   string
	LastName    string
	Email       string
	Password    string
	Preferences map[string]any
}
