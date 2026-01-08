using Toybox.Graphics as G;

import Toybox.Lang;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;

class DateWidget
{
    public function draw(dc as G.Dc, x as Number, y as Number, color as Number, font as WatchUi.FontResource) as Void {
        var info = Gregorian.info(Time.now(), Time.FORMAT_LONG);
        var dateStr = Lang.format("$1$ $2$", [info.day_of_week.toUpper(), info.day]);

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, font, dateStr, Graphics.TEXT_JUSTIFY_CENTER);
    }
}