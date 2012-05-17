package main

import (
	"code.google.com/p/go.net/websocket"
	"net/http"
	"fmt"
)

type DisplayParameter struct {
	Remark string
	Duration string
	Path string
	Rotate string
}

func echoJsonServer(ws *websocket.Conn) {
	fmt.Printf("jsonServer %#v\n", ws.Config())
	for {
		var param DisplayParameter
		err := websocket.JSON.Receive(ws, &param)
		if err != nil {
			fmt.Println(err)
			break
		}
		fmt.Printf("recv:%#v\n", param)

		// Send send a text message serialized T as JSON.
		err = websocket.JSON.Send(ws, param)
		if err != nil {
			fmt.Println(err)
			break
		}
		fmt.Printf("send:%#v\n", param)
	}
}

func main() {
	http.Handle("/echo", websocket.Handler(echoJsonServer))
	fmt.Println("serving...")
	port := 8080
	err := http.ListenAndServe(fmt.Sprintf(":%d", port), nil)
	if err != nil {
		panic("ListenAndServer: " + err.Error())
	}
}