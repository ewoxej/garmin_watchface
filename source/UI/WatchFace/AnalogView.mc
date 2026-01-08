using Toybox.Application as App;

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

    private var _garminLogo as BitmapResource?;
    private var _screenCenterPoint as Array<Number>?;
    private var _screenWidth as Number?;
    private var _settings as SettingsProvider?;
    private var _faceBitmap as BitmapResource?;

    private var _isAwake as Boolean;
    private var _watchFace as WatchFaceView;
    private var _dateWidget as DateWidget;
    private var _timeWidget as TimeWidget;
    private var _weatherWidget as WeatherWidget;
    private var _sunsetSunriseWidget as SunsetSunriseWidget;

    public function initialize() {
        WatchFace.initialize();

        _watchFace = new WatchFaceView(WatchUi.loadResource($.Rez.Fonts.ledboard));
        _dateWidget = new DateWidget();
        _timeWidget = new TimeWidget();
        _weatherWidget = new WeatherWidget();
        _sunsetSunriseWidget = new SunsetSunriseWidget();
        _isAwake = true;
    }

    private function getScreenRelevantSize(factor as Float)
    {
        return (_screenWidth * factor).toNumber();
    }

    public function onLayout(dc as Dc) as Void {

        _faceBitmap = WatchUi.loadResource($.Rez.Drawables.FaceBitmap);
        _font = WatchUi.loadResource($.Rez.Fonts.ledboard) as FontResource;
        _weatherFont = WatchUi.loadResource($.Rez.Fonts.WeatherFont) as FontResource;
        _garminLogo = WatchUi.loadResource($.Rez.Drawables.GarminLogo) as BitmapResource;
        _screenCenterPoint = [dc.getWidth() / 2, dc.getHeight() / 2] as Array<Number>;
        _screenWidth = dc.getWidth();

        _settings = SettingsProvider.getInstance();
        _watchFace.onLayout(dc, _settings.getSecondaryColor());
    }

    private function drawWidgetByName(dc as Dc, name as Number,pos as Array)
    {
        var primaryColor = _settings.getOption("primary_color", _isAwake);
        switch(name)
        {
            case SettingsProvider.WNothing:
            {
                break;
            }
            case SettingsProvider.WDate:
            {
                _dateWidget.draw(dc, pos[0], pos[1], primaryColor, _font);
                break;
            }
            case SettingsProvider.WWeather:
            {
                _weatherWidget.draw(dc, pos[0], pos[1], _settings.getSecondaryColor(), _weatherFont);
                break;
            }
            case SettingsProvider.WSunset:
            {
                _sunsetSunriseWidget.draw(dc, pos[0], pos[1], _font, _weatherFont);
                break;
            }
            case SettingsProvider.WTime:
            {
                _timeWidget.draw(dc, pos[0], pos[1], primaryColor, _font);
                break;
            }
            case SettingsProvider.WBrand:
            {
                if(_garminLogo != null)
                {
                    dc.drawBitmap(pos[0] - _garminLogo.getWidth()/2,
                    pos[1] - _garminLogo.getHeight()/2,_garminLogo);
                }
                break;
            }
            default:
            {
                break;
            }
        }
    }
    public function onUpdate(dc as Dc) as Void {

        if ($.gSettingsChanged) {
			$.gSettingsChanged = false;
			_settings.retrieveSettings();
		}

        var quarter1 = getScreenRelevantSize(0.25);
        var quarter2 = getScreenRelevantSize(0.75);
        var half = getScreenRelevantSize(0.5);

        drawBackground(dc, _settings.getOption("face_watch", _isAwake));

        var topPosition = [half, quarter1];
        var bottomPosition = [half,quarter2];
        var leftPosition = [quarter1, half];
        var rightPosition = [quarter2, half];
        drawWidgetByName(dc,_settings.getOption("wgt_top", _isAwake),topPosition as Array);
        drawWidgetByName(dc,_settings.getOption("wgt_bottom", _isAwake),bottomPosition as Array);
        drawWidgetByName(dc,_settings.getOption("wgt_left", _isAwake),leftPosition as Array);
        drawWidgetByName(dc,_settings.getOption("wgt_right", _isAwake),rightPosition as Array);

        _watchFace.draw(dc, _settings.getOption("seconds", true), _settings.getOption("face_watch", _isAwake),
        _settings.getSecondaryColor(), _settings.getArborColor(_isAwake));
        drawBattery(dc);
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

    private function drawBattery(dc as Dc)
    {
        if(_settings.getOption("battery_arc", _isAwake))
        {
            var cX = _screenCenterPoint[0];
            var cY = _screenCenterPoint[1];
            var batteryValue = ((System.getSystemStats().battery + 0.5)/100);
            var startAngle = 90;
            var endAngle = startAngle - 360 * batteryValue;
            var penWidth = 2;
            dc.setColor(_settings.getOption("primary_color", _isAwake), Graphics.COLOR_TRANSPARENT);
            dc.setPenWidth(penWidth);
            dc.drawArc(cX,cY,getScreenRelevantSize(0.5) - penWidth,Graphics.ARC_CLOCKWISE, startAngle, endAngle);
        }
        if(_settings.getOption("battery_days", _isAwake))
        {
            var value = System.getSystemStats().batteryInDays.toNumber();
            var angle = (value * 6) * (Math.PI/180);
            var cos = Math.cos(angle);
            var sin = Math.sin(angle);
            var length = getScreenRelevantSize(0.45);
            var x = (cos-(-length)*sin+0.5) + _screenCenterPoint[0];
            var y = (sin+(-length)*cos+0.5) + _screenCenterPoint[1];
            dc.fillCircle(x, y, 3);
        }
    }

    public function onEnterSleep() as Void {
        _isAwake = false;
        WatchUi.requestUpdate();
    }

    public function onExitSleep() as Void {
        _isAwake = true;
    }
}

//! Receives watch face events
class AnalogDelegate extends WatchUi.WatchFaceDelegate {
    private var _view as AnalogView;

    //! Constructor
    //! @param view The analog view
    public function initialize(view as AnalogView) {
        WatchFaceDelegate.initialize();
        _view = view;
    }

    public function onPowerBudgetExceeded(powerInfo as WatchFacePowerInfo) as Void {
        System.println("Average execution time: " + powerInfo.executionTimeAverage);
        System.println("Allowed execution time: " + powerInfo.executionTimeLimit);
    }
}
