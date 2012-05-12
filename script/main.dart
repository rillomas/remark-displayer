#import("dart:html");
#import("dart:isolate", prefix:"isolate");
#import("RemarkDisplayer.dart");
#import("CSSRemarkDisplayer.dart");
#import("SVGRemarkDisplayer.dart");
#import("Unit.dart");

/*
class MessageTypes {
    static final int ERROR = -1;
    static final int OK = 0;
    static final int SETUP = 1;
    static final int INIT = 2;
    static final int DISPLAY = 3;
}

class DisplayerState {
    static final int SETUP = 1;
    static final int INITIALIZED = 2;
    static final int DISPLAYING = 3;
}

void isolateMain() {
    final int MAX_NUMBER_OF_REMARKS = 10;
    var displayer = new RemarkDisplayer(MAX_NUMBER_OF_REMARKS);
    isolate.port.receive((message, SendPort replyTo) {
            dispatchIsolate(displayer, message, replyTo, port.toSendPort());
    });
}

void dispatchIsolate(RemarkDisplayer displayer, var message, SendPort replyTo, SendPort myPort) {
    int action = message['action'];
    var arg = message['arg'];
    switch(action) {
    case MessageTypes.INIT:
        displayer.initialize(arg); // EXCEPTION FIRED HERE
        replyTo.send(DisplayerState.INITIALIZED, myPort);
        break;
    case MessageTypes.DISPLAY:
        displayer.display(arg);
        replyTo.send(DisplayerState.DISPLAYING, myPort);
        break;
    }
}

void dispatchMain(var message, SendPort replyTo, SendPort myPort) {
    switch(message) {
    case DisplayerState.INITIALIZED:
        var msg = { 
            "action" : MessageTypes.DISPLAY,
            "arg" : "adsfasfas"
        };
        replyTo.send(msg, myPort);
        break;
    case DisplayerState.DISPLAYING:
        replyTo.close();
        break;
    }
}
*/

void main() {
    /*
    final receivePort = new isolate.ReceivePort();
    receivePort.receive((var message, SendPort sendPort) {
            print("received ${message}");
            dispatchMain(message, sendPort, receivePort.toSendPort());
        });
    
    var sendPort = isolate.spawnFunction(isolateMain);
    var msg = { 
        "action" : MessageTypes.INIT,
        "arg" : "#stage"
    };
    sendPort.send(msg, receivePort.toSendPort());
    */
    
    final int MAX_NUMBER_OF_REMARKS = 10;
    final int MAX_SPEED = 100;

    /*
    var ssList = document.styleSheets;
    CSSStyleSheet sheet = ssList[1];
    var displayer = new CSSRemarkDisplayer(sheet);
    displayer.initialize("#stage", MAX_NUMBER_OF_REMARKS);
    */

    

    /*
    var displayer = new SVGRemarkDisplayer();
    displayer.initialize("#stage", MAX_NUMBER_OF_REMARKS);

    var postButton = document.query("#postRemark");
    InputElement speed = document.query("#displaySpeed");
    TextAreaElement textNode = document.query("#remarkText");
    postButton.on.click.add((Event e) {
            var num = speed.valueAsNumber;
            var duration = (MAX_SPEED - num.toInt()) * 100;
            var param = new DisplayParameter(textNode.value, duration, Unit.Millisecond);
            displayer.display(param);
    });
    */
}
