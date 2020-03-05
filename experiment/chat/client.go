package main
import "github.com/gorilla/websocket"

type Client struct {
	socket *websocket.Conn
	room *room
	send chan byte[]	
}