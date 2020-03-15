package main

import (
	"chata/auth"
	"chata/room"
	"html/template"
	"log"
	"net/http"
	"path/filepath"
	"sync"

	"github.com/stretchr/gomniauth"
	"github.com/stretchr/gomniauth/providers/google"
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
	gomniauth.SetSecurityKey("ahahaha")
	gomniauth.WithProviders(
		google.New("650909378810-oot1pf49hkjikbebnbv5okq4qoigifcd.apps.googleusercontent.com", "Uf7GCMLqDlf7vTyvrbEDlwhm", "http://localhost:8080/auth/callback/google"),
	)

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

// client-id: 650909378810-oot1pf49hkjikbebnbv5okq4qoigifcd.apps.googleusercontent.com
// client-secret: Uf7GCMLqDlf7vTyvrbEDlwhm
