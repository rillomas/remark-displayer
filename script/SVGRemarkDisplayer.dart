#library("SVGRemarkDisplayer");
#import("dart:html");
#import("RemarkDisplayer.dart");

/**
 * Class that displays remarks via SVG
 */
class SVGRemarkDisplayer implements RemarkDisplayer {
    SVGRemarkDisplayer() {
        _remarkList = new List<SVGElement>();
        _currentRemark = 0;
        _numberOfRemarks = 0;
    }

    /**
     * Create remark nodes under the tag with the given ID
     */
    void initialize(String stageID, int numberOfRemarks) {
        _numberOfRemarks = numberOfRemarks;
        var stage = document.query(stageID);

        var svg = new SVGSVGElement();
        for (int i=0; i<numberOfRemarks; i++) {
            SVGGElement g = new SVGElement.svg("<g></g>");
            _remarkList.add(g);
            svg.nodes.add(g);
        }

       stage.nodes.add(svg);
       _root = svg;
    }

    /**
     * Display given remark at the current node
     */
    void display(DisplayParameter parameter) {
        var node = _remarkList[_currentRemark];

        // delete any nodes we already have
        node.nodes.clear();

        // convert text to svg
        var lines = parameter.remark.split("\n");
        SVGTextElement text = new SVGElement.svg("<text font-family='IPA モナーPゴシック' y='300'></text>");
        for (int i=0; i<lines.length; i++) {
            var line = lines[i];
            SVGTSpanElement span = new SVGElement.svg("<tspan x='0' dy='15'>${line}</tspan>");
            text.nodes.add(span);
            //list.add(span);
        }
        
        node.nodes.add(text);
        var duration = "${parameter.duration}${parameter.durationUnit.toString()}";
        SVGAnimateElement fade
            = new SVGElement.svg("<animate attributeName='opacity' from='1' to='0' dur='${duration}' begin='indefinite' fill='freeze' />");
        //SVGAnimationElement animation
        //     = new SVGElement.svg("<animateTransform attributeName='transform' type='translate' from='0' to='1300' dur='${duration}' fill='freeze' begin='indefinite' />");
        SVGAnimationElement path
             = new SVGElement.svg("<animateMotion path='M 50,100 Q40,75 90,70Q95,60 95,50Q180,40 170,100Z' dur='${duration}' fill='freeze' begin='indefinite' />");
        node.nodes.add(path);
        node.nodes.add(fade);
        path.beginElement();
        fade.beginElement();

        // proceed to next remark
        _currentRemark++;
        if (_currentRemark >= _numberOfRemarks) {
            _currentRemark = 0;
        }
    }

    int _numberOfRemarks;
    List<SVGElement> _remarkList;
    int _currentRemark;
    SVGSVGElement _root;
}