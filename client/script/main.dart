#import("dart:html");
#import("dart:isolate", prefix:"isolate");
#import("dart:json");
#import("RemarkDisplayer.dart");
#import("SVGRemarkDisplayer.dart");
#import("Unit.dart");

void main() {
    // initialize displayers
    final int MAX_NUMBER_OF_REMARKS = 15;
    final int MAX_SPEED = 100;
    var displayer = new SVGRemarkDisplayer();
    displayer.initialize("#stage", MAX_NUMBER_OF_REMARKS);

    // create websocket and add handlers
    WebSocket webSocket = new WebSocket("ws://127.0.0.1:8080/echo");
    Element status = document.query("#statusArea");
    webSocket.on.open.add((event) {
            //status.innerHTML = "<p>opened</p>";
        });
    webSocket.on.close.add((event) {
            //status.innerHTML = "<p>closed</p>";
        });
    webSocket.on.message.add((event) {
            // display remark with given parameters
            var message = event.data;
            Map<String, String> map = JSON.parse(message);
            DisplayParameter param = new DisplayParameter.map(map);
            displayer.display(param);
        });

    // connect post button with websocket
    TextAreaElement textNode = document.query("#remarkText");
    TextAreaElement pathNode = document.query("#pathString");
    Element postButton = document.query("#postRemark");
    InputElement speedNode = document.query("#displaySpeed");
    InputElement rotateNode = document.query("#rotateRemark");
    postButton.on.click.add((Event e) {
        String message = textNode.value;
        String path = pathNode.value;

        bool rotate = rotateNode.checked;
        var num = speedNode.valueAsNumber;
        var duration = (MAX_SPEED - num.toInt()) * 100;
        var param = new DisplayParameter(message, duration, Unit.Millisecond, path, rotate);
        String paramJson = JSON.stringify(param.toMap());
        webSocket.send(paramJson);
    });
}
