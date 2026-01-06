import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.Weather;

class WeatherProvider
{
    public enum {Sunrise, Sunset}
    private var _weatherConditions as Dictionary;
    private var _weatherSymbols as Dictionary;
    public function initialize() 
    {
        _weatherConditions = {
        :cloudConditions => [Weather.CONDITION_MOSTLY_CLOUDY,Weather.CONDITION_CLOUDY,
        Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN,Weather.CONDITION_CLOUDY_CHANCE_OF_SNOW,
        Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW, Weather.CONDITION_THIN_CLOUDS],
        :partlyCloudConditions => [Weather.CONDITION_PARTLY_CLOUDY,Weather.CONDITION_PARTLY_CLEAR],
        :fogConditions => [Weather.CONDITION_FOG, Weather.CONDITION_HAZY,Weather.CONDITION_HAIL,
        Weather.CONDITION_MIST,Weather.CONDITION_DUST,Weather.CONDITION_SMOKE,Weather.CONDITION_HAZE, Weather.CONDITION_FAIR],
        :lightningConditions => [Weather.CONDITION_THUNDERSTORMS,Weather.CONDITION_TROPICAL_STORM,Weather.CONDITION_CHANCE_OF_THUNDERSTORMS, 
        Weather.CONDITION_SCATTERED_THUNDERSTORMS],
        :clearConditions => [Weather.CONDITION_CLEAR,Weather.CONDITION_UNKNOWN_PRECIPITATION,Weather.CONDITION_MOSTLY_CLEAR,
        Weather.CONDITION_UNKNOWN,Weather.CONDITION_SLEET,Weather.CONDITION_ICE],
        :rainConditions => [Weather.CONDITION_RAIN,Weather.CONDITION_SCATTERED_SHOWERS,Weather.CONDITION_LIGHT_RAIN,
        Weather.CONDITION_HEAVY_RAIN,Weather.CONDITION_LIGHT_SHOWERS,Weather.CONDITION_SHOWERS,Weather.CONDITION_HEAVY_SHOWERS,
        Weather.CONDITION_CHANCE_OF_SHOWERS,Weather.CONDITION_FREEZING_RAIN,Weather.CONDITION_DRIZZLE],
        :snowConditions => [Weather.CONDITION_SNOW,Weather.CONDITION_WINTRY_MIX,Weather.CONDITION_LIGHT_SNOW,Weather.CONDITION_HEAVY_SNOW, Weather.CONDITION_ICE_SNOW,
        Weather.CONDITION_LIGHT_RAIN_SNOW,Weather.CONDITION_HEAVY_RAIN_SNOW,Weather.CONDITION_RAIN_SNOW,
        Weather.CONDITION_CHANCE_OF_SNOW,Weather.CONDITION_CHANCE_OF_RAIN_SNOW],
        :windyConditions => [Weather.CONDITION_WINDY,Weather.CONDITION_TORNADO,Weather.CONDITION_SQUALL,Weather.CONDITION_SAND,
        Weather.CONDITION_SANDSTORM,Weather.CONDITION_VOLCANIC_ASH,
        Weather.CONDITION_HURRICANE,Weather.CONDITION_FLURRIES]};

        _weatherSymbols =  
        {:cloudConditions => "C",:partlyCloudConditions => "P", 
        :fogConditions =>"F", :lightningConditions => "L",
        :clearConditions => "S", :rainConditions => "R",
        :snowConditions =>"*", :windyConditions =>"W"};
    }

    private function isNight(conditions as Weather.CurrentConditions) as Boolean
    {
        var location = conditions.observationLocationPosition;
        var time = Time.now();
        var sunset = Weather.getSunset(location,time);
        var sunrise = Weather.getSunrise(location,time);
        var isNight = sunset.lessThan(time) || sunrise.greaterThan(time);
        return isNight;
    }

    public function matchWeatherSymbol(conditions as Weather.CurrentConditions) as String
    {
        var replaceDict = {"C"=>"B","S"=>"N","P"=>"B"};
        for(var i = 0; i < _weatherConditions.size();++i)
        {
            var item = _weatherConditions.values()[i];
            if(item != null)
            {
                var result = (item as Array).indexOf(conditions.condition);
                if(result != -1)
                {
                    var letter = _weatherSymbols.values()[i];
                    if(replaceDict.hasKey(letter) && isNight(conditions))
                    {
                        letter = replaceDict[letter];
                    }
                    return letter;
                }
            }
        }
        return "";
    }
    
    public function getNextSunEvent(conditions as Weather.CurrentConditions) as Dictionary
    {
        var location = conditions.observationLocationPosition;
        var timeNow = Time.now();
        var today = Time.today();
        var tomorrow = today.add(new Time.Duration(Gregorian.SECONDS_PER_DAY));

        var eventType = WeatherProvider.Sunrise;
        var sunEvent = Weather.getSunrise(location, today);
        if(sunEvent.compare(timeNow)<0)
        {
            eventType = WeatherProvider.Sunset;
            sunEvent = Weather.getSunset(location, today);
        }
        if(sunEvent.compare(timeNow)<0)
        {
            eventType = WeatherProvider.Sunrise;
            sunEvent = Weather.getSunrise(location, tomorrow);
        }
        var timeInfo = Gregorian.info(sunEvent, Time.FORMAT_LONG);
        
        return {:eventType => eventType, :timeInfo => timeInfo};
    }

}