using Toybox.Graphics as G;

import Toybox.Lang;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;

class SunsetSunriseWidget extends BaseWidget
{
    private var _weatherProvider as WeatherProvider;
    private var _font as FontResource;
    private var _iconsFont as FontResource;

    public function initialize(font as FontResource, iconsFont as FontResource)
    {
        _weatherProvider = new WeatherProvider();
        _font = font;
        _iconsFont = iconsFont;
    }
    
    public function draw(dc as G.Dc, pos as Array) as Void {
        var conditions = Weather.getCurrentConditions();
        if(conditions == null || conditions.observationLocationPosition == null)
        {
            return;
        }

        var sunEventInfo = _weatherProvider.getNextSunEvent(conditions);
        var eventTypeDict = {WeatherProvider.Sunrise => "r", WeatherProvider.Sunset => "s"};
        var dataString = sunEventInfo[:timeInfo].hour.format("%02d")+"."+sunEventInfo[:timeInfo].min.format("%02d");
        dc.drawText(pos[0],pos[1],_font, dataString, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(pos[0],pos[1]-70, _iconsFont, eventTypeDict.get(sunEventInfo[:eventType]), Graphics.TEXT_JUSTIFY_CENTER);
    }
}