
import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.Lang;
using Rez.Strings as Str;

class SettingsProvider
{
    static public enum {FHandsDigits,FMinimal,FStandard,FCount}
    static public enum {WNothing,WDate,WTime,WBrand,WWeather,WSunset,WCount}
    static public const FCountAon = 2;
    static public const WCountAon = 4;
    private var _settingsDict as Dictionary = new Dictionary();

    static private var instance as SettingsProvider?;

    static public function getInstance() as SettingsProvider
    {
        if(instance == null)
        {
            instance = new SettingsProvider();
        }
        return instance;
    }

    private function initialize()
    {
        _settingsDict = {
        "primary_color" => Graphics.COLOR_ORANGE,
        "face_watch" => FStandard,
        "seconds" => true,
        "battery_arc" => true,
        "battery_days" => true,
        "wgt_top" => WDate,
        "wgt_bottom" => WSunset,
        "wgt_left" => WBrand,
        "wgt_right" => WWeather,
        "face_watch_aon" => FHandsDigits,
        "battery_arc_aon" => true,
        "wgt_top_aon" => WDate,
        "wgt_bottom_aon" => WTime,
        "wgt_left_aon" => WNothing,
        "wgt_right_aon" => WNothing};
    }

	public function retrieveSettings() {
        var keys = _settingsDict.keys();
        for (var i = 0; i < keys.size(); i++) {
            var key = keys[i] as String;
            var value = _settingsDict.get(key);
            var storageResult = Storage.getValue(key);
            if(storageResult != null)
            {
               _settingsDict.put(key, storageResult);
            }
        }
    }

	public function saveSettings() {
        var keys = _settingsDict.keys();
        for (var i = 0; i < keys.size(); i++) {
            var key = keys[i] as String;
            var value = _settingsDict.get(key);
            Storage.setValue(key, value);
        }
    }

    public function getOption(name as String, isAwake as Boolean)
    {
        return _settingsDict.get(name + (isAwake ? "" : "_aon"));
    }

    public function setOption(isAwake as Boolean, name as String, option as Object)
    {
        _settingsDict.put(isAwake ? name : name + "_aon", option);
    }

    public function getArborColor(isAwake as Boolean)
    {
        return isAwake ? (getOption(Helpers.configMapping[Str.ShowSeconds], true) ? Graphics.COLOR_RED : Graphics.COLOR_DK_GRAY) : Graphics.COLOR_DK_GRAY;
    }

    public function getSecondaryColor()
    {
        return Graphics.COLOR_LT_GRAY;
    }

    public function getMaxForNextOption(name as String, isAwake as Boolean)
    {
        return name.equals(Helpers.configMapping[Str.WatchFace]) ? (isAwake ? FCount : FCountAon) : (isAwake ? WCount : WCountAon);
    }

    public function nextOption(name as String, isAwake as Boolean) as Number
    {
        var value = getOption(name, isAwake);
        var maxValue = getMaxForNextOption(name, isAwake);
        ++value;
        if(value >= maxValue)
        {
            value = 0;
        }
        setOption(isAwake, name, value);
        return value;
    }
}