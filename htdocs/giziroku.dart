#library ('GizirokuClient');

#import ('dart:html');
#import ('dart:json');

class GizirokuClient {
  
  final Element _user;
  final Element _content;
  final Element _changeLog;

  int _userId;
  String _oldContent;
  
  WebSocket _webSocket;
  
  GizirokuClient()
  : _user = document.query('#user'),
    _content = document.query('#content'),
    _changeLog = document.query('#changeLog')
  {}
  
  void run() {
    _oldContent = "";
    _content.contentEditable = "true";
    
    _webSocket = new WebSocket("ws://localhost:8000/edit");
    _webSocket.on.open.add((e) {
      log("connected");
    });
    _webSocket.on.message.add((e) {
      log("receive:${e.data}");
      Map m = JSON.parse(e.data);
      if (m.containsKey("userId")) {
        _userId = m['userId'];
        _user.innerHTML = "${_userId}";
      }
      if (m.containsKey("content")) {
        _content.innerHTML = m["content"];
      }
    });

    window.setTimeout(_watch, 1000);
  }
  
  void _watch() {
    bool changed = false;
    
    String oldContent = _oldContent;
    Element newContent = _content;
    
    changed = _hasContentChanged(
      new Element.html('<div>$oldContent</div>'), newContent);
    
    if (changed) {
      log('changed');
      _oldContent = newContent.innerHTML;
      _webSocket.send(newContent.innerHTML);
    }
    
    window.setTimeout(_watch, 1000);
  }
  
  bool _hasContentChanged(Element oldContent, Element newContent) {
    Collection<Element> oldChildren = oldContent.elements;
    Collection<Element> newChildren = newContent.elements;
    
    Iterator<Element> oldIte = oldChildren.iterator();
    Iterator<Element> newIte = newChildren.iterator();
    
    while (oldIte.hasNext() && newIte.hasNext()) {
      if (_hasContentChanged(oldIte.next(), newIte.next())) {
        return true;
      }
    }
    
    if (oldIte.hasNext() != newIte.hasNext()) {
      log("change:${newIte.hasNext()}");
      return true;
    }
    
    if (oldContent.text != newContent.text) {
      log("change:'${oldContent.text}':'${newContent.text}'");
      return true;
    }
    
    return false;
  }
  
  void log(String message) {
    //_changeLog.elements.add(new Element.html('<li>${new Date.now()}: $message</li>'));
  }
  
}

main() {
  new GizirokuClient().run();
}
