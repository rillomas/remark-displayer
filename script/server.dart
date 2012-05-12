#import("dart:io");
 
void main() {
    HttpServer httpServer = new HttpServer();
    WebSocketHandler webSocketHandler = new WebSocketHandler();
    httpServer.addRequestHandler((HttpRequest request) => true, webSocketHandler.onRequest);

    // list of all connections
    List<WebSocketConnection> connectionList = new List<WebSocketConnection>();

    webSocketHandler.onOpen = (WebSocketConnection connection) {
        connectionList.add(connection);
        print("connection num: ${connectionList.length}");
        connection.onMessage = (String message) {
            // broadcast
            print("[client] $message");
            connectionList.forEach((c) => c.send(message));
            /*
            if (message == "bye") {
                connection.close(0, "bye command.");
                print("connection closed.");
            } else {
                print("[client] $message");
                connection.send(message);
            }
            */
        };
        
        connection.onClosed = (int status, String reason) {
            print("on closed. STATUS: $status REASON: $reason");
            connectionList.removeRange(connectionList.indexOf(connection), 1);
        };
        
        connection.onError = (e) {
            print("on error. $e");
            connectionList.removeRange(connectionList.indexOf(connection), 1);
        };
    };
    
    httpServer.listen("127.0.0.1", 8080);
    print("running...");
}