
import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;

class SettingsProvider
{
    static public enum {FHandsDigits,FMinimal,FStandard}
    static public enum {WNothing,WDate,WTime,WBrand,WWeather,WSunset}
    private var _settings as Array?;
    private var _settingsDict as Dictionary?;

    private var primaryColor as Number?;
    private var primaryColorAlwaysOn as Number?;
    private var arborColor as Number?;
    private var secondaryColor as Number?;
    private var faceWatch as Number?;
    private var showSeconds as Boolean?;
    private var showBatteryArc as Boolean?;
    private var showDaysRemained as Boolean?;
    private var faceWatchAlwaysOn as Number?;
    private var showBatteryArcAlwaysOn as Boolean?;
    private var widgetTop as Number?;
    private var widgetBottom as Number?;
    private var widgetLeft as Number?;
    private var widgetRight as Number?;
    private var widgetTopAlwaysOn as Number?;
    private var widgetBottomAlwaysOn as Number?;
    private var widgetLeftAlwaysOn as Number?;
    private var widgetRightAlwaysOn as Number?;

    private const _maxWidgetsForAwake = 6;
    private const _maxWidgetsForAlwaysOn = 4;
    private const _maxFacesForAwake = 3;
    private const _maxFacesForAlwaysOn = 2;

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
        primaryColorAlwaysOn = Graphics.COLOR_DK_GRAY;
        arborColor = Graphics.COLOR_RED;
        secondaryColor = Graphics.COLOR_LT_GRAY;
    }

    public function getStorageOrDefault(key as String, def)
    {
        var storageResult = Storage.getValue(key);
        if(storageResult == null)
        {
           return def;
        } 
        return storageResult;
    }

	public function retrieveSettings() {
       primaryColor = getStorageOrDefault("primary_color", Graphics.COLOR_ORANGE);
       faceWatch = getStorageOrDefault("face_watch",FStandard);
       showSeconds = getStorageOrDefault("seconds",true);
       showBatteryArc = getStorageOrDefault("battery_arc",true);
       showDaysRemained = getStorageOrDefault("battery_days",true);
       faceWatchAlwaysOn = getStorageOrDefault("face_watch_aon",FHandsDigits);
       showBatteryArcAlwaysOn = getStorageOrDefault("battery_arc_aon",true);
       widgetTop = getStorageOrDefault("wgt_top",WDate);
       widgetBottom = getStorageOrDefault("wgt_bottom",WSunset);
       widgetLeft = getStorageOrDefault("wgt_left",WBrand);
       widgetRight = getStorageOrDefault("wgt_right",WWeather);
       widgetTopAlwaysOn = getStorageOrDefault("wgt_top_aon",WDate);
       widgetBottomAlwaysOn = getStorageOrDefault("wgt_bottom_aon",WTime);
       widgetLeftAlwaysOn = getStorageOrDefault("wgt_left_aon",WNothing);
       widgetRightAlwaysOn = getStorageOrDefault("wgt_right_aon",WNothing);
    }

	public function saveSettings() {
       Storage.setValue("primary_color", primaryColor);
       Storage.setValue("face_watch", faceWatch);
       Storage.setValue("seconds",showSeconds);
       Storage.setValue("battery_arc",showBatteryArc);
       Storage.setValue("battery_days",showDaysRemained);
       Storage.setValue("face_watch_aon",faceWatchAlwaysOn);
       Storage.setValue("battery_arc_aon",showBatteryArcAlwaysOn);
       Storage.setValue("wgt_top",widgetTop);
       Storage.setValue("wgt_bottom",widgetBottom);
       Storage.setValue("wgt_left",widgetLeft);
       Storage.setValue("wgt_right",widgetRight);
       Storage.setValue("wgt_top_aon",widgetTopAlwaysOn);
       Storage.setValue("wgt_bottom_aon",widgetBottomAlwaysOn);
       Storage.setValue("wgt_left_aon",widgetLeftAlwaysOn);
       Storage.setValue("wgt_right_aon",widgetRightAlwaysOn);
    }

    public function getPrimaryColor(isAwake as Boolean){
        return isAwake ? primaryColor : primaryColorAlwaysOn;
    }
    public function getFaceWatch(isAwake as Boolean){
        return isAwake ? faceWatch : faceWatchAlwaysOn;
    }
    public function getShowSeconds(isAwake as Boolean){
        return isAwake ? showSeconds : false;
    }
    public function getShowBatteryArc(isAwake as Boolean){
        return isAwake ? showBatteryArc : showBatteryArcAlwaysOn;
    }
    public function getShowDaysRemained(isAwake as Boolean){
        return isAwake ? showDaysRemained : false;
    }
    public function getWidgetTop(isAwake as Boolean){
        return isAwake ? widgetTop : widgetTopAlwaysOn;
    }
    public function getWidgetBottom(isAwake as Boolean){
        return isAwake ? widgetBottom : widgetBottomAlwaysOn;
    }
    public function getWidgetLeft(isAwake as Boolean){
        return isAwake ? widgetLeft : widgetLeftAlwaysOn;
    }
    public function getWidgetRight(isAwake as Boolean){
        return isAwake ? widgetRight : widgetRightAlwaysOn;
    }

    public function getArborColor(isAwake as Boolean)
    {
        return isAwake ? (showSeconds ? arborColor : primaryColorAlwaysOn) : primaryColorAlwaysOn;
    }
    public function getSecondaryColor()
    {
        return secondaryColor;
    }
    public function setPrimaryColor(isAwake as Boolean, color as Number)
    {
        if(isAwake)
        {
            primaryColor = color;
        }
        else
        {
            primaryColorAlwaysOn = color;
        }
    }
    public function setFaceWatch(isAwake as Boolean, face as Number)
    {
        if(isAwake)
        {
            faceWatch = face;
        }
        else
        {
            faceWatchAlwaysOn = face;
        }
    }

    public function nextFaceWatch(isAwake as Boolean) as Number
    {
        var value = getCheckedValue(getFaceWatch(isAwake),isAwake ? _maxFacesForAwake : _maxFacesForAlwaysOn);
        setFaceWatch(isAwake, value);
        return value;
    }

    public function setShowSeconds(show as Boolean)
    {
        showSeconds = show;
    }
    public function setShowBatteryArc(isAwake as Boolean, show as Boolean)
    {
        if(isAwake)
        {
            showBatteryArc = show;
        }
        else
        {
            showBatteryArcAlwaysOn = show;
        }
    }
    public function setShowDaysRemained(show as Boolean)
    {
        showDaysRemained = show;
    }

    public function setWidgetTop(isAwake as Boolean, widget as Number)
    {
        if(isAwake)
        {
            widgetTop = widget;
        }
        else
        {
            widgetTopAlwaysOn = widget;
        } 
    }
    public function setWidgetBottom(isAwake as Boolean, widget as Number)
    {
        if(isAwake)
        {
            widgetBottom = widget;
        }
        else
        {
            widgetBottomAlwaysOn = widget;
        } 
    }
    public function setWidgetLeft(isAwake as Boolean, widget as Number)
    {
        if(isAwake)
        {
            widgetLeft = widget;
        }
        else
        {
            widgetLeftAlwaysOn = widget;
        } 
    }

    public function setWidgetRight(isAwake as Boolean, widget as Number)
    {
        if(isAwake)
        {
            widgetRight = widget;
        }
        else
        {
            widgetRightAlwaysOn = widget;
        } 
    }

    public function getCheckedValue(value,maxValue) as Number
    {
        ++value;
        if(value>=maxValue)
        {
            value = 0;
        }
        return value;
    }

    public function nextWidgetTop(isAwake as Boolean) as Number
    {
        var value = getCheckedValue(getWidgetTop(isAwake),isAwake ? _maxWidgetsForAwake : _maxWidgetsForAlwaysOn);
        setWidgetTop(isAwake, value);
        return value;
    }

    public function nextWidgetBottom(isAwake as Boolean) as Number
    {
        var value = getCheckedValue(getWidgetBottom(isAwake),isAwake ? _maxWidgetsForAwake : _maxWidgetsForAlwaysOn);
        setWidgetBottom(isAwake, value);
        return value;
    }
    public function nextWidgetLeft(isAwake as Boolean) as Number
    {
        var value = getCheckedValue(getWidgetLeft(isAwake),isAwake ? _maxWidgetsForAwake : _maxWidgetsForAlwaysOn);
        setWidgetLeft(isAwake, value);
        return value;
    }
    public function nextWidgetRight(isAwake as Boolean) as Number
    {
        var value = getCheckedValue(getWidgetRight(isAwake),isAwake ? _maxWidgetsForAwake : _maxWidgetsForAlwaysOn);
        setWidgetRight(isAwake, value);
        return value;
    }
}