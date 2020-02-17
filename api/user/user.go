package user

import (
	"encoding/json"
	"log"
	"net/http"
)

// Handlers type
type Handlers struct {
	logger *log.Logger
}

// LoginInfo Placeholder for username and password
type LoginInfo struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

// User Handle User info
func (h *Handlers) User(w http.ResponseWriter, r *http.Request) {
	// Provide content type to give golang hint which response we are sending back (speed up)
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	w.Write([]byte(`{"message": "hello world"}`))
}

// Login Handle login request
func (h *Handlers) Login(w http.ResponseWriter, r *http.Request) {
	if r.Method == http.MethodPost {
		/**
		* As with all structs in Go, it’s important to remember that only fields with
		* a capital first letter are visible to external programs like the JSON Marshaller | Unmarshaller
		*
		* The json package only accesses the exported fields of struct types (those that begin with an uppercase letter).
		* Therefore only the the exported fields of a struct will be present in the JSON output.
		*
		* any unexported fields in the destination struct will be unaffected by Unmarshal
		* https://blog.golang.org/json-and-go
		 */
		var i LoginInfo
		err := json.NewDecoder(r.Body).Decode(&i)
		if err != nil {
			h.logger.Println(err)
			w.WriteHeader(http.StatusBadRequest)
			return
		}
		// Check empty string
		if i.Username+"gopher" != "gopher" && i.Password+"gopher" != "gopher" {
			w.Header().Set("Content-Type", "application/json")
			w.WriteHeader(http.StatusOK)
			w.Write([]byte(`{token: 123465416123123}`))
			return
		}
		w.WriteHeader(http.StatusBadRequest)
		return
	}
	w.WriteHeader(http.StatusNotFound)
}

// NewHandlers  create a user handler with injected dependency
func NewHandlers(logger *log.Logger) *Handlers {
	return &Handlers{
		logger: logger,
	}
}


