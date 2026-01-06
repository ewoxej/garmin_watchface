import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.Time;
import Toybox.WatchUi;

class WatchHand
{
    public enum {Hour,Minute,Second}
    private var _centerPoint as Array<Number>;
    private var _type as Number;
    private var _handLength as Number;
    private var _tailLength as Number;
    private var _beginWidth as Number;
    private var _endWidth as Number;
    private var _enableShadow as Boolean;
    private var _color as Number;

    public function initialize(dict as Dictionary)
    {
        _centerPoint = dict[:centerPoint];
        _type = dict[:type];
        _handLength = dict[:handLength];
        _tailLength = dict[:tailLength];
        _beginWidth = dict[:beginWidth];
        if(dict.hasKey(:endWidth))
        {
            _endWidth = dict[:endWidth];
        }
        else
        {
            _endWidth = _beginWidth;
        }
        if(dict.hasKey(:enableShadow))
        {
            _enableShadow = dict[:enableShadow];
        }
        else
        {
            _enableShadow = false;
        }
        _color = dict[:color];
    }

    private function calculateAngle() as Float
    {
        var clockTime = System.getClockTime();
        if(_type == Hour)
        {
            var hourHandAngle = (((clockTime.hour % 12) * 60) + clockTime.min);
            hourHandAngle = hourHandAngle / (12 * 60.0);
            hourHandAngle = hourHandAngle * Math.PI * 2;
            return hourHandAngle;
        }
        else if(_type == Minute)
        {
            var minuteHandAngle = (clockTime.min / 60.0) * Math.PI * 2;
            return minuteHandAngle;
        }
        else if(_type == Second)
        {
            var secondHandAngle = (clockTime.sec / 60.0) * Math.PI * 2;
            return secondHandAngle;
        }
        return 0.0;
    }

    private function generateHandCoordinates(handLength as Number, tailLength as Number, beginWidth as Number, endWidth as Number) as Array< Array<Float> > {
        var coords = [[-(beginWidth / 2), tailLength] as Array<Number>,
                      [-(endWidth / 2), -handLength] as Array<Number>,
                      [endWidth / 2, -handLength] as Array<Number>,
                      [beginWidth / 2, tailLength] as Array<Number>] as Array< Array<Number> >;

        var result = new Array< Array<Float> >[4];
        var angle = calculateAngle();
        var cos = Math.cos(angle);
        var sin = Math.sin(angle);

        // Transform the coordinates
        for (var i = 0; i < 4; i++) {
            var x = (coords[i][0] * cos) - (coords[i][1] * sin) + 0.5;
            var y = (coords[i][0] * sin) + (coords[i][1] * cos) + 0.5;

            result[i] = [_centerPoint[0] + x, _centerPoint[1] + y] as Array<Float>;
        }

        return result;
    }

    public function getHandCaptionCoordinates(length as Number) as Array<Number>
    {
        var angle = calculateAngle();
        var cos = Math.cos(angle);
        var sin = Math.sin(angle);
        var x = (cos-(-length)*sin+0.5) + _centerPoint[0];
        var y = (sin+(-length)*cos+0.5) + _centerPoint[1];
        return [x,y];
    }

    public function render(dc as Dc) as Void
    {
        if(_enableShadow)
        {
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
            dc.fillPolygon(generateHandCoordinates(_handLength + 1, _tailLength + 1, (_beginWidth * 1.6).toNumber(), _endWidth));
        }
        dc.setColor(_color, Graphics.COLOR_TRANSPARENT);
        var polygon = generateHandCoordinates(_handLength, _tailLength, _beginWidth, _endWidth);
        dc.fillPolygon(polygon);
    }
}