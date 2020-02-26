package main

import (
	"log"
	"mote/user"
	"net/http"
	"os"

	"github.com/gorilla/mux"
)

type server struct{}

func main() {
	// Logger init: Show date timme, file name, line of code when logging
	logger := log.New(os.Stdout, "mote", log.LstdFlags|log.Lshortfile)
	// Router ini
	r := mux.NewRouter()

	h := user.NewHandlers(logger)
	logger.Println("Server is starting...")

	r.HandleFunc("/user", h.User).Methods("POST")
	r.HandleFunc("/login", h.Login).Methods("POST")
	// Handle error, so we will know what happened when it crashed
	logger.Fatal(http.ListenAndServe(":8080", r))
}
