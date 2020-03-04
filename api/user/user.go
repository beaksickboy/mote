package user

import (
	"context"
	"encoding/json"
	"log"
	"mote/bsbmail"
	"mote/validation"
	"net/http"
	"time"

	"github.com/dgrijalva/jwt-go"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
)

// Handlers type
type Handlers struct {
	logger  *log.Logger
	client  *mongo.Client
	mailing *bsbmail.MailHanlder
}

// LoginInfo Placeholder for username and password
type LoginInfo struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type signUpInfo struct {
	Username string `json:"username"`
	Password string `json:"password"`
	Email    string `json:"email"`
	Phone    string `json:"phone"`
}

type User struct {
	Username string
	Password string
	Email    string
	Phone    string
}

type UserResponse struct {
	Username string `json:"username"`
	Email    string `json:"email"`
	Phone    string `json:"phone"`
	Token    string `json:"token"`
}

type Claims struct {
	id int
	jwt.StandardClaims
}

// User Handle User info
func (h *Handlers) User(w http.ResponseWriter, r *http.Request) {
	var i signUpInfo
	if err := json.NewDecoder(r.Body).Decode(&i); err != nil {
		h.logger.Println(err)
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	if validation.IsEmpty(i.Email) || validation.IsEmpty(i.Password) || validation.IsEmpty(i.Phone) || validation.IsEmpty(i.Username) {
		h.logger.Println("props inside body must not be empty")
		w.WriteHeader(http.StatusBadGateway)
		return
	}

	collection := h.client.Database("mote").Collection("user")
	ctx, _ := context.WithTimeout(context.Background(), time.Second*3)

	var user bson.M
	if err := collection.FindOne(ctx, bson.M{"email": i.Email, "username": i.Username}).Decode(&user); err == nil {
		h.logger.Printf("Duplicate user info %s", user)
		w.WriteHeader(http.StatusConflict)
		return
	}

	// Not found
	_, err := collection.InsertOne(ctx, i)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	w.WriteHeader(http.StatusCreated)
	w.Write([]byte("{created: true}"))
	h.mailing.SendMail([]string{i.Email})
	return

}

// Login Handle login request
func (h *Handlers) Login(w http.ResponseWriter, r *http.Request) {
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

	if validation.IsEmpty(i.Email) || validation.IsEmpty(i.Password) {
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
		h.logger.Println(err)
		w.WriteHeader(http.StatusInternalServerError)
	}
	var responseBody UserResponse
	ctx, _ := context.WithTimeout(context.Background(), time.Second*5)

	if err := h.client.Database("mote").Collection("user").FindOne(ctx, bson.M{
		"email":    i.Email,
		"password": i.Password,
	}).Decode(&responseBody); err != nil {
		h.logger.Println(err)
		w.WriteHeader(http.StatusNoContent)
		return
	}
	responseBody.Token = s

	if err := json.NewEncoder(w).Encode(&responseBody); err != nil {
		h.logger.Println(err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
}

// NewHandlers  create a user handler with injected dependency
func NewHandlers(logger *log.Logger, client *mongo.Client, mailing *bsbmail.MailHanlder) *Handlers {
	return &Handlers{
		logger:  logger,
		client:  client,
		mailing: mailing,
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
