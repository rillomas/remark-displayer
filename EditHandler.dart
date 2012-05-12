#library ('GizirokuServer');

#import ('dart:io');

class EditHandler {
  
  final String _contextPath;
  
  final WebSocketHandler handler;
  
  final List<WebSocketConnection> activeConn;
  
  EditHandler(String this._contextPath)
  : handler = new WebSocketHandler(),
    activeConn = new List<WebSocketConnection>()
  {
    handler.onOpen = handle;
  }
  
  void onRequest(HttpRequest req, HttpResponse res) {
    return handler.onRequest(req, res);
  }
  
  void handle(final WebSocketConnection conn) {
    activeConn.add(conn);
    conn.send('{"userId":${activeConn.indexOf(conn)}}');
    
    Function close = () {
      activeConn.removeRange(activeConn.indexOf(conn), 1);
    };
    
    conn.onMessage = (var message) {
      print("recevied(${activeConn.indexOf(conn)}):$message");
      if (conn == activeConn[0]) {
        int n = 0;
        activeConn.filter((e) => e != conn)
                  .forEach((e) {
                    print(n++);
                    e.send('{"content":"$message"}');
                  });
      }
    };

    conn.onClosed = (int status, String reason) {
      print('Closed with $status for $reason.');
      close();
    };
    
    conn.onError = (e) {
      print('Error was $e.');
      close();
    };
  }

}
