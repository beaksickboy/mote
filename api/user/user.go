package user

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/dgrijalva/jwt-go"
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

type Claims struct {
	id int
	jwt.StandardClaims
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

	if r.Method != http.MethodPost {
		w.WriteHeader(http.StatusNotFound)
		return
	}
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
	if i.Username+"gopher" == "gopher" || i.Password+"gopher" == "gopher" {
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	secretKey := []byte("ronsan")
	claims := Claims{
		id: 1,
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: time.Now().Add(5 * time.Minute).Unix(),
		},
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, &claims)
	s, err := token.SignedString(secretKey)

	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	w.Write([]byte(fmt.Sprintf("{token: %s}", s)))
}

// NewHandlers  create a user handler with injected dependency
func NewHandlers(logger *log.Logger) *Handlers {
	return &Handlers{
		logger: logger,
	}
}

/*
https://stackoverflow.com/questions/17000835/token-authentication-vs-cookies
https://security.stackexchange.com/questions/180357/store-auth-token-in-cookie-or-header
https://www.youtube.com/watch?v=67mezK3NzpU

- Dont compare JWT with Cookie, bcz they are different stuff
- Token by reference (Session Id)
- Token by value (JWT)

> Benefit of JWT over session id, dont have to has db to store those session id
*/

/*
Session id
- store in db
- When scaling => multiple instance -> load balancer with sticky session + distributed cache
- Dont want to use one cache server => bc if this server down => lose every thing
*/

/*
Cookies
- Secure Httponly will stop any js code from access cookie
*/

/*
JWT
Signartures
- Symmetric: Shared secret
- Asymmetric: Private key, Public key
*/

// CSRF | XSRF
