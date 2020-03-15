package auth

import (
	"fmt"
	"log"
	"net/http"
	"strings"
)

type authHandler struct {
	next http.Handler
}

func (h *authHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	// Check cookie exist
	_, err := r.Cookie("auth")
	if err == http.ErrNoCookie {
		// Redirect to login page
		w.Header().Set("Location", "/login")
		w.WriteHeader(http.StatusTemporaryRedirect)
		return
	}
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	h.next.ServeHTTP(w, r)
}

// /auth/action/provider
func LoginHandler(w http.ResponseWriter, r *http.Request) {
	segs := strings.Split(r.URL.Path, "/")
	action := segs[2]
	provider := segs[3]
	fmt.Println(action)

	switch action {
	case "login":
		log.Println("login", provider)
	default:
		w.WriteHeader(http.StatusNotFound)
	}
}

func MustAuth(handler http.Handler) http.Handler {
	return &authHandler{next: handler}
}
