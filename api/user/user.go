package user

import (
	"log"
	"net/http"
)

// Handlers type
type Handlers struct {
	logger *log.Logger
}

// User Handle User info
func (h *Handlers) User(w http.ResponseWriter, r *http.Request) {
	// Provide content type to give golang hint which response we are sending back (speed up)
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	w.Write([]byte(`{"message": "hello world"}`))
}

// NewHandlers  create a user handler with injected dependency
func NewHandlers(logger *log.Logger) *Handlers {
	return &Handlers{
		logger: logger,
	}
}
