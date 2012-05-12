#import("dart:io");

void main() {
  HttpServer httpServer = new HttpServer();
  WebSocketHandler webSocketHandler = new WebSocketHandler();
  httpServer.addRequestHandler((HttpRequest request) => true, webSocketHandler.onRequest);

  final List<WebSocketConnection> activeConn = new List<WebSocketConnection>();
  webSocketHandler.onOpen = (WebSocketConnection connection) {

    Function close = () {
      activeConn.removeRange(activeConn.indexOf(connection), 1);
    };

    activeConn.addLast(connection);
    print("on open. member = " + activeConn.length);
    connection.send("[server] welcome." + activeConn.length);

    connection.onMessage = (message) {
      print("===" + message);
      if (message == "bye") {
        connection.close(0, "bye command.");
        print("connection closed.");
      } else {
        print("[client] $message");
        activeConn.filter((c) => c != connection)
        .forEach((c) => c.send("[server] $message"));
      }
    };

    connection.onClosed = (int status, String reason) {
      print("on closed. STATUS: $status REASON: $reason");
      close();
    };

    connection.onError = (e) {
      print("on error. $e");
    };

  };

  httpServer.listen("127.0.0.1", 8080);
  print("running...");
}