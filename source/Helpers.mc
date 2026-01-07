import Toybox.Lang;
using Rez.Strings as Str;

class Helpers
{                    
    static public var configMapping = {
        Str.PrimaryColor => "primary_color",
        Str.WatchFace => "face_watch",
        Str.ShowSeconds => "seconds",
        Str.ShowBatteryArc => "battery_arc",
        Str.ShowDaysRemained => "battery_days",
        Str.WidgetPosTop => "wgt_top",
        Str.WidgetPosBottom => "wgt_bottom",
        Str.WidgetPosLeft => "wgt_left",
        Str.WidgetPosRight => "wgt_right"};

    static public var watchFacesMapping = {
        SettingsProvider.FHandsDigits => Str.WatchFaceHandsDigits,
        SettingsProvider.FMinimal => Str.WatchFaceMinimal,
        SettingsProvider.FStandard => Str.WatchFaceStandard
    };
    static public var widgetsMapping = {
        SettingsProvider.WNothing => Str.WidgetNothing,
        SettingsProvider.WDate => Str.WidgetDate,
        SettingsProvider.WTime => Str.WidgetTime,
        SettingsProvider.WBrand => Str.WidgetBrand,
        SettingsProvider.WWeather => Str.WidgetWeather,
        SettingsProvider.WSunset => Str.WidgetSunset};
}