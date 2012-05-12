#library ('GizirokuServer');

#import ('dart:io');

class ManageHandler {
  
  final String _CONTENT_TYPE = "text/plain;charset=utf-8";
  final String _htdocs = "./_htdocs";
  final String _contextPath;
  
  ManageHandler(String this._htdocs, String this._contextPath)
  {}
  
  void onRequest(HttpRequest req, HttpResponse res) {
    String path = req.path.substring(_contextPath.length);
    path = path == "" || path == "/" ? "/index.html" : path;
    print("onRequest: ${path}");
    
    if (req.method == "GET") {
      File resource = new File("${_htdocs}${path}");
      resource.exists().then((found) {
        if (! found) {
          do404(req, res);
        } else {
          resource.openInputStream().pipe(res.outputStream);
        }
      });
    }
    else {
      do405(req, res);
    }
  }
  
  void do404(HttpRequest req, HttpResponse res) {
    res.headers.set(HttpHeaders.CONTENT_TYPE, _CONTENT_TYPE);
    res.statusCode = HttpStatus.NOT_FOUND;
    res.outputStream.writeString("Resource not found.");
    res.outputStream.close();
  }
  
  void do405(HttpRequest req, HttpResponse res) {
    res.headers.set(HttpHeaders.CONTENT_TYPE, _CONTENT_TYPE);
    res.statusCode = HttpStatus.METHOD_NOT_ALLOWED;
    res.outputStream.writeString("Method not found.");
    res.outputStream.close();
  }
  
}
