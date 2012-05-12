#import("dart:io");
 
void main() {
    HttpServer httpServer = new HttpServer();
    WebSocketHandler webSocketHandler = new WebSocketHandler();
    httpServer.addRequestHandler((HttpRequest request) => true, webSocketHandler.onRequest);
    webSocketHandler.onOpen = (WebSocketConnection connection) {
        print("on open.");
        connection.send("[server] welcome.");
        
        connection.onMessage = (message) {
            if (message == "bye") {
                connection.close(0, "bye command.");
                print("connection closed.")
                    } else {
                print("[client] $message");
                connection.send("[server] $message");
            }
        };
        
        connection.onClosed = (int status, String reason) {
            print("on closed. STATUS: $status REASON: $reason");
        };
        
        connection.onError = (e) {
            print("on error. $e");
        };
    };
    
    httpServer.listen("127.0.0.1", 8080);
    print("running...");
}