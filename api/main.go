package main

import (
	"log"
	"mote/user"
	"net/http"
	"os"
)

type server struct{}

func main() {
	// Show date timme, file name, line of code when logging
	logger := log.New(os.Stdout, "mote", log.LstdFlags|log.Lshortfile)
	h := user.NewHandlers(logger)
	logger.Println("Server is starting...")

	http.HandleFunc("/user", h.User)
	http.HandleFunc("/login", h.Login)
	// Handle error, so we will know what happened when it crashed
	logger.Fatal(http.ListenAndServe(":8080", nil))
}
