using Rez.Strings as Str;

import Toybox.Lang;

class Helpers
{                    
    static public var configMapping as Dictionary= {
        Str.PrimaryColor => "primary_color",
        Str.SecondaryColor => "secondary_color",
        Str.WatchFace => "face_watch",
        Str.ShowSeconds => "seconds",
        Str.ShowBatteryArc => "battery_arc",
        Str.ShowDaysRemained => "battery_days",
        Str.WidgetPosTop => "wgt_top",
        Str.WidgetPosBottom => "wgt_bottom",
        Str.WidgetPosLeft => "wgt_left",
        Str.WidgetPosRight => "wgt_right"};

    static public var watchFacesMapping as Dictionary = {
        SettingsProvider.FHandsDigits => Str.WatchFaceHandsDigits,
        SettingsProvider.FMinimal => Str.WatchFaceMinimal,
        SettingsProvider.FStandard => Str.WatchFaceStandard
    };
    static public var widgetsMapping as Dictionary = {
        SettingsProvider.WNothing => Str.WidgetNothing,
        SettingsProvider.WDate => Str.WidgetDate,
        SettingsProvider.WTime => Str.WidgetTime,
        SettingsProvider.WBrand => Str.WidgetBrand,
        SettingsProvider.WWeather => Str.WidgetWeather,
        SettingsProvider.WSunset => Str.WidgetSunset};
}