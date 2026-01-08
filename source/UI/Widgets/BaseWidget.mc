using Toybox.Graphics as G;

import Toybox.Lang;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;
import Toybox.Test;

class BaseWidget
{
    public function draw(dc as G.Dc, position as Array) as Void {
        Test.assert(position.size() == 2);
    }
}