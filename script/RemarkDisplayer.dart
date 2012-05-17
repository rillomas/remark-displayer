#library("RemarkDisplayer");
#import("dart:html");
#import("Unit.dart");
/**
 * Parameter for displaying
 */
class DisplayParameter {
    DisplayParameter(this.remark, this.duration, this.durationUnit, this.path, this.rotate);

    DisplayParameter.map(Map<String, String> map) {
        remark = map["remark"];
        path = map["path"];
        String durationStr = map["duration"];
        List strList = durationStr.split(_separator);
        duration = Math.parseInt(strList[0]);
        durationUnit = new Unit(strList[1]);
        String rotateStr = map["rotate"];
        rotate = (rotateStr == "true");
    }

    String remark;
    int duration;
    Unit durationUnit;
    String path;
    bool rotate;

    Map<String, String> toMap() {
        Map<String, String> map = new Map<String, String>();
        map["remark"] = remark;
        map["duration"] = "${duration}${_separator}${durationUnit.toString()}";
        map["path"] = path;
        map["rotate"] = "${rotate}";
        return map;
    }

    final String _separator = "&";
}

/**
 * Class that manages remark display
 */
interface RemarkDisplayer {
    /**
     * Display given remark
     */
    void display(DisplayParameter param);
}
