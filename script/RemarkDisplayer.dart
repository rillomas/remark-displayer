#library("RemarkDisplayer");
#import("dart:html");
#import("ElementAnimator.dart");
#import("Unit.dart");

/**
 * Parameter for displaying
 */
class DisplayParameter {
    DisplayParameter(this.remark, this.duration, this.durationUnit);
    String remark;
    int duration;
    Unit durationUnit;
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
