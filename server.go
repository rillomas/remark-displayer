package main

import (
	"code.google.com/p/go.net/websocket"
	"net/http"
	"fmt"
)

type RequestType int
type ResponseType int

var (
	requestQueue = make(chan Request)
	responseQueue = make(chan Response)
)

const (
	// Request
	GENERATE_CLIENT_ID RequestType = 0
	ADD_CLIENT RequestType = 1
	REMOVE_CLIENT RequestType = 2
	BROADCAST RequestType = 3

	// Response
	CLIENT_ID ResponseType = 0
)

type RequestParameter struct {
	clientID int
	Connection *websocket.Conn
}

type DisplayParameter struct {
	Remark string
	Duration string
	Path string
	Rotate string
}

type Request interface {
	Type() RequestType
	ClientID() int
	Process(clientList []*websocket.Conn, queue chan Response, currentClientID *int) []*websocket.Conn
}

type GenerateClientIDRequest struct {
	RequestParameter
}

type BroadcastRequest struct {
	RequestParameter
	DisplayParameter
}

type AddClientRequest struct {
	RequestParameter
}

type RemoveClientRequest struct {
	RequestParameter
}

type Response interface {
	Type() ResponseType
}

type GenerateClientIDResponse struct {
	ClientID int
}

func (gcr GenerateClientIDResponse) Type() ResponseType {
	return CLIENT_ID
}

func (gcm GenerateClientIDRequest) ClientID() int {
	return gcm.clientID
}

func (gcm GenerateClientIDRequest) Type() RequestType {
	return GENERATE_CLIENT_ID
}

func (gcm GenerateClientIDRequest) Process(clientList []*websocket.Conn, queue chan Response, currentClientID *int) []*websocket.Conn {
	res := GenerateClientIDResponse {
		*currentClientID,
	}
	queue <- res
	// proceed to next id
	*currentClientID++
	return clientList
}



func (acm AddClientRequest) ClientID() int {
	return acm.clientID
}

func (acm AddClientRequest) Type() RequestType {
	return ADD_CLIENT
}

func (acm AddClientRequest) Process(clientList []*websocket.Conn, queue chan Response, currentClientID *int) []*websocket.Conn {
	return append(clientList, acm.Connection)
}

func (bm BroadcastRequest) ClientID() int {
	return bm.clientID
}

func (bm BroadcastRequest) Type() RequestType {
	return BROADCAST
}

func (bm BroadcastRequest) Process(clientList []*websocket.Conn, queue chan Response, currentClientID *int) []*websocket.Conn  {
	// send a text message serialized as JSON.
	for _, client := range clientList {
		fmt.Println("Sending")
		err := websocket.JSON.Send(client, bm.DisplayParameter)
		if err != nil {
			fmt.Println(err)
			// remove client
		}
	}
	fmt.Println("Broadcasted")
	return clientList
}

func (rcm RemoveClientRequest) ClientID() int {
	return rcm.clientID
}

func (rcm RemoveClientRequest) Type() RequestType {
	return REMOVE_CLIENT
}

func (rcm RemoveClientRequest) Process(clientList []*websocket.Conn, queue chan Response, currentClientID *int) []*websocket.Conn  {
	// remove client
	return clientList
}

func manageClient(reqQueue chan Request, resQueue chan Response) {
	var currentClientID int = 0
	clientList := make([]*websocket.Conn, 0)
	fmt.Println("Entering client manage loop")
	for {
		select {
		case msg := <- reqQueue:
			fmt.Printf("client:%d type:%d\n", msg.ClientID(), msg.Type())
			clientList = msg.Process(clientList, resQueue, &currentClientID)
		}
	}
}

func generateClientID(reqQueue chan Request, resQueue chan Response)  int {
	msg := GenerateClientIDRequest {}
	reqQueue <- msg
	res := <- resQueue
	v, _ := res.(GenerateClientIDResponse)
	return v.ClientID
}

func serveClient(ws *websocket.Conn, reqQueue chan Request, resQueue chan Response) {
	id := generateClientID(reqQueue, resQueue)
	defer func() {
		// remove client when exiting
		msg := RemoveClientRequest {
			RequestParameter {
				id,
				ws,
			},
		}
		reqQueue <- msg
	}()

	// add client first
	msg := AddClientRequest {
		RequestParameter {
			id,
			ws,
		},
	}
	fmt.Println("Adding client")
	reqQueue <- msg
	fmt.Println("Entering receive loop")

	for {
		var param DisplayParameter
		err := websocket.JSON.Receive(ws, &param)
		if err != nil {
			fmt.Printf("receive error: %s\n",err)
			break
		}
		fmt.Printf("recv:%#v\n", param)

		// broadcast received message
		msg := BroadcastRequest {
			RequestParameter {
				id,
				ws,
			},
			param,
		}
		reqQueue <- msg
	}
}

func echoJsonServer(ws *websocket.Conn) {
	fmt.Printf("jsonServer %#v\n", ws.Config())
	serveClient(ws, requestQueue, responseQueue)
}

func mainServer(w http.ResponseWriter, req *http.Request) {
	path := req.URL.Path[1:]
	fmt.Printf("path: %s\n",path)
	http.ServeFile(w, req, path)
}

func main() {
	go manageClient(requestQueue, responseQueue)
	http.Handle("/echo", websocket.Handler(echoJsonServer))
	http.HandleFunc("/", mainServer)
	fmt.Println("serving...")
	port := 8080
	err := http.ListenAndServe(fmt.Sprintf(":%d", port), nil)
	if err != nil {
		panic("ListenAndServer: " + err.Error())
	}
}