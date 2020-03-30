package movie

import (
	"context"
	"encoding/json"
	"log"
	"net/http"
	"strings"
	"time"

	"github.com/gorilla/mux"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
)

type MovieDetail struct {
	ShortName string
	// Url base on id of movies and episode
	Name          string
	Type          string
	Description   string
	Genres        []int
	Authors       []int
	TotalEpisodes int
	ImageUrl      string
}

type MovieType struct {
	Type string             `json:"type"`
	Id   primitive.ObjectID `json:"id" bson:"_id"`
}

type Handler struct {
	log    *log.Logger
	client *mongo.Client
}

// anime
// cinema
// series
func (h *Handler) GetMovieType(w http.ResponseWriter, r *http.Request) {
	typeCollection := h.client.Database("movie").Collection("type")
	ctx, _ := context.WithTimeout(context.Background(), time.Second*1)

	cur, err := typeCollection.Find(ctx, bson.M{})
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
	}
	defer cur.Close(ctx)

	var types = make([]MovieType, 3, 3)
	h.log.Println(cur)
	if err = cur.All(ctx, &types); err != nil {
		h.log.Println("Cursor decode", err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	h.log.Println(types)

	if err := cur.Err(); err != nil {
		h.log.Println("Cursor Error", err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	if err = json.NewEncoder(w).Encode(&types); err != nil {
		h.log.Println("Encode Error", err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
}

func (h *Handler) GetMoviesByType(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	if string(vars["type"]) == "" {
		w.WriteHeader(http.StatusBadRequest)
		h.log.Println("Parameter must not null")
		return
	}

	types := strings.Split(vars["type"], ",")
	typeCollection := h.client.Database("movie").Collection("movies")
	ctx, _ := context.WithTimeout(context.Background(), time.Second*2)

	matchStage := bson.D{primitive.E{
		Key: "$match",
		Value: bson.D{
			primitive.E{
				Key: "type",
				Value: bson.D{
					primitive.E{
						Key:   "$in",
						Value: types,
					},
				},
			},
		},
	}}

	groupStage := bson.D{primitive.E{
		Key: "$group",
		Value: bson.D{
			primitive.E{
				Key:   "_id",
				Value: "$type",
			},
			primitive.E{
				Key: "movies",
				Value: bson.D{
					primitive.E{
						Key:   "$push",
						Value: "$$ROOT",
					},
				},
			},
		},
	}}

	cursor, err := typeCollection.Aggregate(ctx, mongo.Pipeline{matchStage, groupStage})
	if err != nil {
		h.log.Println("Aggregate failed", err)
		w.WriteHeader(http.StatusInternalServerError)
	}
	var data []bson.M
	if err = cursor.All(ctx, &data); err != nil {
		h.log.Println("Decode error", &data)
	}

	h.log.Println(data)

}

func (h *Handler) GetMovieDetail(w http.ResponseWriter, r *http.Request) {
	// vars := mux.Vars(r)
	// get movie info via id
	// get movieinfo via database
	// get movies
}

func (h *Handler) AddMovies(w http.ResponseWriter, r *http.Request) {
	// r.GetBody
}

func NewHandlers(log *log.Logger, client *mongo.Client) *Handler {
	return &Handler{
		log:    log,
		client: client,
	}
}
