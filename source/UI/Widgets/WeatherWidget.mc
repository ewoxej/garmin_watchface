using Toybox.Graphics as G;

import Toybox.Lang;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;

class WeatherWidget
{
    private var _weatherProvider as WeatherProvider;

    public function initialize()
    {
        _weatherProvider = new WeatherProvider();
    }
    
    public function draw(dc as G.Dc, x as Number, y as Number, color as Number, font as WatchUi.FontResource) as Void {
        var conditions = Weather.getCurrentConditions();
        if(conditions == null || conditions.observationLocationPosition == null
           || conditions.condition == null || conditions.temperature == null)
        {
            return;
        }
        var resultString = _weatherProvider.matchWeatherSymbol(conditions);
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x,y,Graphics.FONT_SYSTEM_XTINY,conditions.temperature.toString()+"°C",Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(x,y-95,font, resultString, Graphics.TEXT_JUSTIFY_CENTER); 
    }
}