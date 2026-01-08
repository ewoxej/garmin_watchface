using Toybox.Graphics as G;

import Toybox.Lang;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;

class TimeWidget
{
    public function draw(dc as G.Dc, x as Number, y as Number, color as Number, font as WatchUi.FontResource) as Void {
        var info = Gregorian.info(Time.now(), Time.FORMAT_LONG);
        var timeStr = Lang.format("$1$.$2$", [info.hour.format("%02d"), info.min.format("%02d")]);

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, font, timeStr, Graphics.TEXT_JUSTIFY_CENTER);
    }
}