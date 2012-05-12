#import('dart:html');

class Client {
  WebSocket webSocket;
  DivElement listDiv;
  InputElement messageInput;

  Client() {
  }

  void onSendButtonClick(Event e) {
    String message = messageInput.value;
    if (!message.isEmpty()) {
      webSocket.send(message);
      messageInput.value = "";
    }
  }

  void run() {
    ButtonElement sendButton = document.query("#send");
    sendButton.on.click.add(onSendButtonClick);

    listDiv = document.query('#list');
    messageInput = document.query('#message');
    document.query('#status').innerHTML = "running...";

    webSocket = new WebSocket("ws://127.0.0.1:8080");
    webSocket.on.open.add((event) {
      listDiv.innerHTML = "${listDiv.innerHTML}#opend.";
    });
    webSocket.on.close.add((event) {
      listDiv.innerHTML = "${listDiv.innerHTML}#closed.";
    });
    webSocket.on.message.add((event) {
      var message = event.data;
      listDiv.innerHTML = "${listDiv.innerHTML}$message<br>";
    });
  }
}

void main() {
  new Client().run();
}