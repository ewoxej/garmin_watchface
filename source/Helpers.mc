import Toybox.Lang;
import Toybox.System;

class Helpers
{
    static public enum {OptionAwake = 65, OptionAlwaysOn, OptionPrimaryColor,
                        OptionWatchFace, OptionWidgets, OptionBatteryArc, OptionBatteryDays,
                        OptionShowSeconds, OptionWTop, OptionWBottom, OptionWLeft, OptionWRight}
                        
    static private var watchFaceDict = {SettingsProvider.FStandard=>"Standard", 
                    SettingsProvider.FHandsDigits=>"Digits near hands", 
                    SettingsProvider.FMinimal=>"Minimal"};

    static private var widgetsDict = {SettingsProvider.WDate=>"Date",SettingsProvider.WWeather=>"Weather",
                   SettingsProvider.WSunset=>"Sunrise/sunset",SettingsProvider.WTime=>"Time",
                   SettingsProvider.WNothing=>"Nothing",SettingsProvider.WBrand=>"Brand"};

    static public function getWatchFaceStringValue(id as Number) as String
    {
        return watchFaceDict.get(id);
    }
    static public function getWidgetStringValue(id as Number) as String
    {
        return widgetsDict.get(id);
    }
}