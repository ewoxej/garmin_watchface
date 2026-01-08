using Toybox.Application as App;
using Rez.Strings as Str;

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;

class AnalogView extends WatchUi.WatchFace {
    private enum {ShowDigitsNearHands, ShowDigitsCenter, DontShowDigits}

    private var _font as FontResource?;
    private var _weatherFont as FontResource?;
    private var _faceBitmap as BitmapResource?;

    private var _settings as SettingsProvider?;
    private var _isAwake as Boolean;

    private var _watchFace as WatchFaceView;
    private var _widgets as Dictionary;
    private var _widgetPositions as Dictionary?;
    private var _batteryView as BatteryView?;

    public function initialize() {
        WatchFace.initialize();

        _watchFace = new WatchFaceView(WatchUi.loadResource($.Rez.Fonts.ledboard));
        _isAwake = true;
        _widgets = { Str.WidgetPosTop => null, Str.WidgetPosBottom => null,
                     Str.WidgetPosLeft => null, Str.WidgetPosRight => null};
    }

    private function calculateWidgetPositions(screenWidth as Number)
    {
        var quarter1 = (screenWidth * 0.25).toNumber();
        var quarter2 = (screenWidth * 0.75).toNumber();
        var half = (screenWidth * 0.5).toNumber();

        return { 
            Str.WidgetPosTop => [half, quarter1], 
            Str.WidgetPosBottom => [half,quarter2],
            Str.WidgetPosLeft => [quarter1, half],
            Str.WidgetPosRight => [quarter2, half]};
    }

    public function getWidget(name as Number)
    {
        var primaryColor = _settings.getOption("primary_color", _isAwake);

        switch(name)
        {
            case SettingsProvider.WDate:
                return new DateWidget(primaryColor, _font);
            case SettingsProvider.WWeather:
                return new WeatherWidget(_settings.getSecondaryColor(), _weatherFont);
            case SettingsProvider.WSunset:
                return new SunsetSunriseWidget(_font, _weatherFont);
            case SettingsProvider.WTime:
                return new TimeWidget(primaryColor, _font);
            case SettingsProvider.WBrand:
                return new BrandWidget(WatchUi.loadResource($.Rez.Drawables.GarminLogo));
        }
        return null;
    }

    public function updateView()
    {
        for(var i = 0; i < _widgets.size(); i++)
        {
            var key = _widgets.keys()[i];
            _widgets[key] = getWidget(_settings.getOption(Helpers.configMapping[key], _isAwake));
        }

        _batteryView.updateColor(_settings.getOption("primary_color", _isAwake));
    }

    public function onLayout(dc as Dc) as Void {

        _faceBitmap = WatchUi.loadResource($.Rez.Drawables.FaceBitmap);
        _font = WatchUi.loadResource($.Rez.Fonts.ledboard) as FontResource;
        _weatherFont = WatchUi.loadResource($.Rez.Fonts.WeatherFont) as FontResource;

        _settings = SettingsProvider.getInstance();
        _watchFace.onLayout(dc, _settings.getSecondaryColor());
        _batteryView = new BatteryView(dc, _settings.getOption("primary_color", _isAwake));

        _widgetPositions = calculateWidgetPositions(dc.getWidth());
        updateView();
    }

    public function onUpdate(dc as Dc) as Void {

        if ($.gSettingsChanged) {
			$.gSettingsChanged = false;
			_settings.retrieveSettings();
            updateView();
		}

        drawBackground(dc, _settings.getOption("face_watch", _isAwake));

        for(var i = 0; i < _widgets.size(); i++)
        {
            var key = _widgets.keys()[i];
            if(_widgets[key] != null)
            {
                _widgets[key].draw(dc, _widgetPositions[key]);
            }
        }

        _watchFace.draw(dc, _settings.getOption("seconds", _isAwake), _settings.getOption("face_watch", _isAwake),
            _settings.getSecondaryColor(), _settings.getArborColor(_isAwake));
        _batteryView.draw(dc, _settings.getOption("battery_arc", _isAwake), 
            _settings.getOption("battery_days", _isAwake));
    }

    private function drawBackground(dc as Dc, watchFace as Number) as Void {
        if(watchFace == SettingsProvider.FStandard)
        {
            dc.drawBitmap(0, 0, _faceBitmap);
        }
        else
        {
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
            dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
        }
    }

    public function onEnterSleep() as Void {
        _isAwake = false;
        updateView();
        WatchUi.requestUpdate();
    }

    public function onExitSleep() as Void {
        _isAwake = true;
        updateView();
    }
}
