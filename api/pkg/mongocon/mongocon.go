package mongocon

import (
	"context"
	"log"
	"time"

	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
	"go.mongodb.org/mongo-driver/mongo/readpref"
)

type MongoCon struct {
	logger *log.Logger
}

func (c *MongoCon) EstablishConnection() (*mongo.Client, *context.Context) {

	ctx, _ := context.WithTimeout(context.Background(), 10*time.Second)
	client, err := mongo.Connect(ctx, options.Client().ApplyURI("mongodb://user-db"))
	if err != nil {
		c.logger.Fatal(err)
	}
	// Ping check connection
	if err := client.Ping(ctx, readpref.Primary()); err != nil {
		c.logger.Fatal(err)
	}
	return client, &ctx
}

func New(logger *log.Logger) *MongoCon {
	return &MongoCon{
		logger: logger,
	}
}
