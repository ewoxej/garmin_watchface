using Toybox.Graphics as G;

import Toybox.Lang;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;

class BrandWidget extends BaseWidget
{
    private var _logo as BitmapResource;

    public function initialize(logo as BitmapResource)
    {
        BaseWidget.initialize();
        _logo = logo;
    }
    
    public function draw(dc as G.Dc, pos as Array) as Void {
        BaseWidget.draw(dc, pos);
        dc.drawBitmap(pos[0] - _logo.getWidth()/2, pos[1] - _logo.getHeight()/2, _logo);
    }
}