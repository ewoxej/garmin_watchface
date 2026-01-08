using Toybox.Graphics as G;

import Toybox.Lang;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;

class TimeWidget extends BaseWidget
{
    private var _color as Number;
    private var _font as FontResource;

    public function initialize(color as Number, font as FontResource)
    {
        BaseWidget.initialize();
        _color = color;
        _font = font;
    }

    public function draw(dc as G.Dc, pos as Array) as Void {
        BaseWidget.draw(dc, pos);
        var info = Gregorian.info(Time.now(), Time.FORMAT_LONG);
        var timeStr = Lang.format("$1$.$2$", [info.hour.format("%02d"), info.min.format("%02d")]);

        dc.setColor(_color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(pos[0], pos[1], _font, timeStr, Graphics.TEXT_JUSTIFY_CENTER);
    }
}