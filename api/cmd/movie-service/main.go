package main

import (
	"context"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/beaksickboy/mote/api/pkg/mongocon"
	"github.com/beaksickboy/mote/api/pkg/movie"
	"github.com/gorilla/mux"
	"go.mongodb.org/mongo-driver/bson"
)

func main() {
	logger := log.New(os.Stdout, "mote", log.LstdFlags|log.Lshortfile)

	r := mux.NewRouter()

	con := mongocon.New(logger)

	client := con.EstablishConnection("mongodb://movie-db")

	ctx, _ := context.WithTimeout(context.Background(), time.Second*10)
	defer client.Disconnect(ctx)

	db, err := client.ListDatabaseNames(ctx, bson.M{})
	if err != nil {
		logger.Fatal(err)
	}
	logger.Println(db)

	// Init handler
	h := movie.NewHandlers(logger, client)

	logger.Println("Server is starting...")
	r.HandleFunc("/movies", h.GetMovies).Methods("GET")
	r.HandleFunc("/movies", h.AddMovies).Methods("POST")

	logger.Fatal(http.ListenAndServe(":8080", r))

}
