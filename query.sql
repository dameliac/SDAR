-- name: AddUser :execresult
INSERT INTO `Users` (`FirstName` , `LastName`, `Preferences`)
VALUES(?,?,?);