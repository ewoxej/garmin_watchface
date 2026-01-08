using Toybox.Graphics as G;

import Toybox.Lang;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;

class SunsetSunriseWidget
{
    private var _weatherProvider as WeatherProvider;

    public function initialize()
    {
        _weatherProvider = new WeatherProvider();
    }
    
    public function draw(dc as G.Dc, x as Number, y as Number, font as WatchUi.FontResource, iconFont as WatchUi.FontResource) as Void {
        var conditions = Weather.getCurrentConditions();
        if(conditions == null || conditions.observationLocationPosition == null)
        {
            return;
        }

        var sunEventInfo = _weatherProvider.getNextSunEvent(conditions);
        var eventTypeDict = {WeatherProvider.Sunrise => "r", WeatherProvider.Sunset => "s"};
        var dataString = sunEventInfo[:timeInfo].hour.format("%02d")+"."+sunEventInfo[:timeInfo].min.format("%02d");
        dc.drawText(x,y,font, dataString, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(x,y-70, iconFont, eventTypeDict.get(sunEventInfo[:eventType]), Graphics.TEXT_JUSTIFY_CENTER);
    }
}