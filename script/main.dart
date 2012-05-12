#import("dart:html");
#import("dart:isolate", prefix:"isolate");
#import("dart:json");
#import("RemarkDisplayer.dart");
#import("SVGRemarkDisplayer.dart");
#import("Unit.dart");

void main() {
    // initialize displayers
    final int MAX_NUMBER_OF_REMARKS = 10;
    final int MAX_SPEED = 100;
    var displayer = new SVGRemarkDisplayer();
    displayer.initialize("#stage", MAX_NUMBER_OF_REMARKS);

    // create websocket and add handlers
    WebSocket webSocket = new WebSocket("ws://127.0.0.1:8080");
    Element status = document.query("#statusArea");
    webSocket.on.open.add((event) {
            status.innerHTML = "<p>opened</p>";
        });
    webSocket.on.close.add((event) {
            status.innerHTML = "<p>closed</p>";
        });
    webSocket.on.message.add((event) {
            var message = event.data;
            print(message);
            Map<String, String> map = JSON.parse(message);
            DisplayParameter param = new DisplayParameter.map(map);
            displayer.display(param);
        });

    // connect post button with websocket
    TextAreaElement textNode = document.query("#remarkText");
    Element postButton = document.query("#postRemark");
    InputElement speed = document.query("#displaySpeed");
    postButton.on.click.add((Event e) {
        String message = textNode.value;
        if (!message.isEmpty()) {
            var num = speed.valueAsNumber;
            var duration = (MAX_SPEED - num.toInt()) * 100;
            var param = new DisplayParameter(message, duration, Unit.Millisecond, "");
            String paramJson = JSON.stringify(param.toMap());
            print(paramJson);
            webSocket.send(paramJson);
        }
    });
}
