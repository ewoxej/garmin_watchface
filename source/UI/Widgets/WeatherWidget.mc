using Toybox.Graphics as G;

import Toybox.Lang;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;

class WeatherWidget extends BaseWidget
{
    private var _weatherProvider as WeatherProvider;
    private var _color as Number;
    private var _font as FontResource;

    public function initialize(color as Number, font as FontResource)
    {
        BaseWidget.initialize();
        _weatherProvider = new WeatherProvider();
        _color = color;
        _font = font;
    }
    
    public function draw(dc as G.Dc, pos as Array ) as Void {
        BaseWidget.draw(dc, pos);
        var conditions = Weather.getCurrentConditions();
        if(conditions == null || conditions.observationLocationPosition == null
           || conditions.condition == null || conditions.temperature == null)
        {
            return;
        }
        var resultString = _weatherProvider.matchWeatherSymbol(conditions);
        dc.setColor(_color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(pos[0],pos[1],Graphics.FONT_SYSTEM_XTINY,conditions.temperature.toString()+"°C",Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(pos[0],pos[1]-95,_font, resultString, Graphics.TEXT_JUSTIFY_CENTER); 
    }
}