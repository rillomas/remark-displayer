#library("RemarkDisplayer");
#import("dart:html");
#import("Unit.dart");
/**
 * Parameter for displaying
 */
class DisplayParameter {
    DisplayParameter(this.remark, this.duration, this.durationUnit, this.path);

    DisplayParameter.map(Map<String, String> map) {
        remark = map["remark"];
        path = map["path"];
        String durationStr = map["duration"];
        List strList = durationStr.split(_separator);
        duration = Math.parseInt(strList[0]);
        durationUnit = new Unit(strList[1]);
    }
    String remark;
    int duration;
    Unit durationUnit;
    String path;

    Map<String, String> toMap() {
        Map<String, String> map = new Map<String, String>();
        map["remark"] = remark;
        map["duration"] = "${duration}${_separator}${durationUnit.toString()}";
        map["path"] = path;
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
