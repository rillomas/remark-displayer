package main

import (
	"code.google.com/p/go.net/websocket"
	"net/http"
	"fmt"
)

var (
	clientList []*websocket.Conn
)

type DisplayParameter struct {
	Remark string
	Duration string
	Path string
	Rotate string
}

func echoJsonServer(ws *websocket.Conn) {
	fmt.Printf("jsonServer %#v\n", ws.Config())
	clientList = append(clientList, ws)
	for {
		var param DisplayParameter
		err := websocket.JSON.Receive(ws, &param)
		if err != nil {
			fmt.Println(err)
			break
		}
		fmt.Printf("recv:%#v\n", param)

		// send a text message serialized as JSON.
		for _, client := range clientList {
			err = websocket.JSON.Send(client, param)
			if err != nil {
				fmt.Println(err)
				break
			}
		}

		if err != nil {
			break
		}
	}
	clientList
}

func MainServer(w http.ResponseWriter, req *http.Request) {
	path := req.URL.Path[1:]
	fmt.Printf("path: %s\n",path)
	http.ServeFile(w, req, path)
}

func main() {
	http.Handle("/echo", websocket.Handler(echoJsonServer))
	http.HandleFunc("/", MainServer)
	fmt.Println("serving...")
	port := 8080
	err := http.ListenAndServe(fmt.Sprintf(":%d", port), nil)
	if err != nil {
		panic("ListenAndServer: " + err.Error())
	}
}