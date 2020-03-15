package main

import (
	"chata/auth"
	"chata/room"
	"html/template"
	"log"
	"net/http"
	"path/filepath"
	"sync"
)

// templ represents a single template
type templateHandler struct {
	once     sync.Once
	filename string
	templ    *template.Template
}

// ServeHTTP handles the HTTP request.
func (t *templateHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	// t.once.Do(func() {
	t.templ = template.Must(template.ParseFiles(filepath.Join("templates",
		t.filename)))
	// })
	t.templ.Execute(w, nil)
}

func main() {
	r := room.NewRoom()
	// root
	http.Handle("/chat", auth.MustAuth(&templateHandler{filename: "chat.html"}))
	http.Handle("/login", &templateHandler{filename: "login.html"})
	http.HandleFunc("/auth/", auth.LoginHandler)
	http.HandleFunc("/room", r.ServeHttp)

	go r.Run()
	// start the web server
	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatal("ListenAndServe:", err)
	}
}
