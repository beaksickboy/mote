package main

import (
	"fmt"
	"log"
	"net/http"
)

type server struct {
}

func (s *server) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	body := `{"message": "hello world"}`
	w.WriteHeader(http.StatusOK)
	w.Header().Set("Content-Type", "application/json")
	w.Write([]byte(body))
}

func main() {
	fmt.Println("Yay")
	s := &server{}
	http.Handle("/", s)
	fmt.Println("Yay")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
