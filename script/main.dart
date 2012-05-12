#import("dart:html");
#import("dart:isolate", prefix:"isolate");
#import("RemarkDisplayer.dart");
#import("SVGRemarkDisplayer.dart");
#import("Unit.dart");

void main() {
    final int MAX_NUMBER_OF_REMARKS = 10;
    final int MAX_SPEED = 100;

    var displayer = new SVGRemarkDisplayer();
    displayer.initialize("#stage", MAX_NUMBER_OF_REMARKS);

    WebSocket webSocket = new WebSocket("ws://127.0.0.1:8080");
    Element status = document.query("#statusArea");
    InputElement speed = document.query("#displaySpeed");
    webSocket.on.open.add((event) {
            status.innerHTML = "<p>opened</p>";
        });
    webSocket.on.close.add((event) {
            status.innerHTML = "<p>closed</p>";
        });
    webSocket.on.message.add((event) {
            var message = event.data;
            var num = speed.valueAsNumber;
            var duration = (MAX_SPEED - num.toInt()) * 100;
            var param = new DisplayParameter(message, duration, Unit.Millisecond);
            displayer.display(param);
        });

    TextAreaElement textNode = document.query("#remarkText");
    Element postButton = document.query("#postRemark");

    postButton.on.click.add((Event e) {
        String message = textNode.value;
        if (!message.isEmpty()) {
            webSocket.send(message);
        }
    });
}
