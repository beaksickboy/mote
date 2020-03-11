package main

import "github.com/gorilla/websocket"

type Client struct {
	socket *websocket.Conn
	room   *room
	send   chan []byte
}

func (c *Client) read() {
	for {
		_, msg, err := c.socket.ReadMessage()

		if err != nil {
			return
		}
		c.room.forward <- msg
	}
}

func (c *Client) write() {
	defer c.socket.Close()
	for msg := range c.send {
		err := c.socket.WriteMessage(websocket.TextMessage, msg)
		if err != nil {
			return
		}
	}
}
