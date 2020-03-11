package main

import (
	"log"
	"net/http"

	// "trace"

	"github.com/gorilla/websocket"
)

type room struct {
	// forward is a channel that holds incoming messages
	// that should be forwarded to the other clients.
	forward chan []byte

	join chan *Client

	leave chan *Client

	clients map[*Client]bool

	// r trace.Tracer
}

func NewRoom() *room {
	return &room{
		forward: make(chan []byte),
		join:    make(chan *Client),
		leave:   make(chan *Client),
		clients: make(map[*Client]bool),
	}
}

func (r *room) run() {
	for {
		// select only run one block of case code at atime === synchonize
		select {
		case client := <-r.join:
			// joining
			r.clients[client] = true
		case client := <-r.leave:
			//leaving
			delete(r.clients, client)
			close(client.send)
		case msg := <-r.forward:
			// forward msg to all clients
			for client := range r.clients {
				client.send <- msg
			}
		}
	}
}

const (
	socketBufferSize  = 1024
	messageBufferSize = 256
)

var upgrader = &websocket.Upgrader{ReadBufferSize: socketBufferSize, WriteBufferSize: socketBufferSize}

func (r *room) ServeHttp(w http.ResponseWriter, req *http.Request) {

	socket, err := upgrader.Upgrade(w, req, nil)

	if err != nil {
		log.Fatal("Serve http error", err)
		return
	}

	client := &Client{
		socket: socket,
		room:   r,
		send:   make(chan []byte, messageBufferSize),
	}

	r.join <- client

	defer func() { r.leave <- client }()

	go client.write()

	client.read()

}
