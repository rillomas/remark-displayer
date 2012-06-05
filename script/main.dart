#import("dart:html");
#import("dart:isolate", prefix:"isolate");
#import("dart:json");
#import("RemarkDisplayer.dart");
#import("SVGRemarkDisplayer.dart");
#import("Unit.dart");


class App {

    App() {
        _settingAreaVisible = true;
    }

    void initialize(RemarkDisplayer displayer) {
        // create websocket and add handlers
        WebSocket webSocket = new WebSocket("ws://localhost:8080/echo");
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
        _setupSettingArea("#settingArea", "#displayArea");
    }


    /**
      * Setup the side bar for setting
      */
    void _setupSettingArea(String settingAreaID, String displayAreaID) {
        Element settingArea = document.query(settingAreaID);
        Element displayArea = document.query(displayAreaID);
        Element btn = document.query("#hideStatus");
        
        btn.on.click.add((Event e) {
                _settingAreaVisible = !_settingAreaVisible;
                if (_settingAreaVisible) {
                    settingArea.style.visibility = "visible";
                    settingArea.style.width = "";
                    settingArea.classes = ["span6"];
                    displayArea.classes = ["offset6", "span6"];
                } else {
                    settingArea.style.visibility = "collapse";
                    settingArea.classes = ["span"];
                    settingArea.style.width = "0px";
                    displayArea.classes = ["span12"];
                }
            });
    }


    final int MAX_SPEED = 100;
    bool _settingAreaVisible;
    RemarkDisplayer _displayer;
}

void main() {
        // initialize displayers
        final int MAX_NUMBER_OF_REMARKS = 15;
        var displayer = new SVGRemarkDisplayer();
        displayer.initialize("#stage", MAX_NUMBER_OF_REMARKS);
        App app = new App();
        app.initialize(displayer);
}
