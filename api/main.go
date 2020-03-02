package main

import (
	"log"
	"mote/bsbmail"
	"mote/mongocon"
	"mote/user"
	"net/http"
	"os"

	"github.com/gorilla/mux"
	"go.mongodb.org/mongo-driver/bson"
)

type server struct{}

func main() {
	// Logger init: Show date timme, file name, line of code when logging
	logger := log.New(os.Stdout, "mote", log.LstdFlags|log.Lshortfile)
	// Router inits
	r := mux.NewRouter()
	// Init smtp
	mailingHanler := bsbmail.NewHandler(logger)
	// Establish db connection
	con := mongocon.New(logger)
	client, ctx := con.EstablishConnection()
	defer client.Disconnect(*ctx)

	db, err := client.ListDatabaseNames(*ctx, bson.M{})
	if err != nil {
		logger.Fatalln(err)
	}

	logger.Println(db)

	// Init handler
	h := user.NewHandlers(logger, client, mailingHanler)

	logger.Println("Server is starting...")

	r.HandleFunc("/user", h.User).Methods("POST")
	r.HandleFunc("/login", h.Login).Methods("POST")
	// Handle error, so we will know what happened when it crashed
	logger.Fatal(http.ListenAndServe(":8080", r))
}
