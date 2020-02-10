package main

import (
    "log"
    "net/http"
	"fmt"
)

type server struct{}

func (s *server) ServeHTTP(w http.ResponseWriter, r *http.Request) {
    w.WriteHeader(http.StatusOK)
    w.Header().Set("Content-Type", "application/json")
    w.Write([]byte(`{"message": "hello world"}`))
}

func main() {
	fmt.Print("Server is starting...")
    s := &server{}
    http.Handle("/", s)
	fmt.Print("Yo")
    log.Fatal(http.ListenAndServe(":8080", nil))
}