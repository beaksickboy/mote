package movie

import (
	"log"
	"net/http"

	"go.mongodb.org/mongo-driver/mongo"
)

type Handler struct {
	log    *log.Logger
	client *mongo.Client
}

func (h *Handler) GetMovies(w http.ResponseWriter, r *http.Request) {

}

movieName
image
introduction




func (h *Handler) AddMovies(w http.ResponseWriter, r *http.Request) {
	// r.GetBody
}

func NewHandlers(log *log.Logger, client *mongo.Client) *Handler {
	return &Handler{
		log:    log,
		client: client,
	}
}
