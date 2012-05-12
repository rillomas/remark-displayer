#library ('GizirokuServer');

#import ('dart:io');
#import ('EditHandler.dart');
#import ('ManageHandler.dart');

class GizirokuServer {
  
  final String _hostname;
  
  final int _port;
  
  final HttpServer _server;
  
  ManageHandler _manageHandler;
  
  EditHandler _editHandler;
  
  GizirokuServer(String this._hostname, int this._port)
  : _server = new HttpServer(),
    _editHandler = new EditHandler("/edit")
  {
    new File(new Options().script).directory().then((Directory d) {
      _manageHandler = new ManageHandler("${d.path}/htdocs", "/gzrk");
      _server.addRequestHandler((HttpRequest req) {
        return req.path.startsWith("/gzrk");
      }, _manageHandler.onRequest);
    });

    _server.addRequestHandler((HttpRequest req) {
      return req.path == "/edit";
    }, _editHandler.onRequest);
  }
  
  void start() {
    _server.listen(_hostname, _port);
  }
  
}
