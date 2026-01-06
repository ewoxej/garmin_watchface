using Toybox.Application as App;

import Toybox.Application.Storage;
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
    private var _garminLogo as BitmapResource?;
    private var _screenCenterPoint as Array<Number>?;
    private var _watchHands as Dictionary?;
    private var _screenWidth as Number?;
    private var _weatherProvider as WeatherProvider?;
    private var _settings as SettingsProvider?;

    private var _isAwake as Boolean;

    public function initialize() {
        WatchFace.initialize();
        _isAwake = true;
    }

    private function getScreenRelevantSize(factor as Float)
    {
        return (_screenWidth * factor).toNumber();
    }

    private function dictionaryCopy(dict as Dictionary)
    {
        var newDict = {};
        var keys = dict.keys();
        var values = dict.values();
        for(var i = 0; i < dict.size(); ++ i)
        {
            newDict.put(keys[i], values[i]);
        }
        return newDict;
    }

    public function onLayout(dc as Dc) as Void {

        _font = WatchUi.loadResource($.Rez.Fonts.ledboard) as FontResource;
        _weatherFont = WatchUi.loadResource($.Rez.Fonts.WeatherFont) as FontResource;
        _faceBitmap = WatchUi.loadResource($.Rez.Drawables.FaceBitmap) as BitmapResource;
        _garminLogo = WatchUi.loadResource($.Rez.Drawables.GarminLogo) as BitmapResource;
        _screenCenterPoint = [dc.getWidth() / 2, dc.getHeight() / 2] as Array<Number>;
        _screenWidth = dc.getWidth();

        _settings = SettingsProvider.getInstance();
        _weatherProvider = new WeatherProvider();

        var baseHandConfig =
        {
            :centerPoint => _screenCenterPoint,
            :tailLength => 20,
            :enableShadow => true,
            :color => _settings.getSecondaryColor()
        };

        var hourHandConfig = dictionaryCopy(baseHandConfig);
        hourHandConfig.put(:type,WatchHand.Hour);
        hourHandConfig.put(:beginWidth,10);
        hourHandConfig.put(:endWidth,2);
        hourHandConfig.put(:handLength,getScreenRelevantSize(0.28));

        var minuteHandConfig = dictionaryCopy(baseHandConfig);
        minuteHandConfig.put(:type,WatchHand.Minute);
        minuteHandConfig.put(:beginWidth,6);
        minuteHandConfig.put(:endWidth,1);
        minuteHandConfig.put(:handLength,getScreenRelevantSize(0.42));

        var secondHandConfig = dictionaryCopy(baseHandConfig);
        secondHandConfig.put(:type,WatchHand.Second);
        secondHandConfig.put(:beginWidth,2);
        secondHandConfig.put(:color,Graphics.COLOR_RED);
        secondHandConfig.remove(:enableShadow);
        secondHandConfig.put(:handLength,getScreenRelevantSize(0.48));

        _watchHands = {:hour_hand => new WatchHand(hourHandConfig), 
                       :minute_hand => new WatchHand(minuteHandConfig),
                       :second_hand => new WatchHand(secondHandConfig)};
    }

    private function drawWidgetByName(dc as Dc, name as Number,pos as Array)
    {
        switch(name)
        {
            case SettingsProvider.WNothing:
            {
                break;
            }
            case SettingsProvider.WDate:
            {
                drawDateString(dc,pos[0],pos[1]);
                break;
            }
            case SettingsProvider.WWeather:
            {
                drawWeatherWidget(dc,pos[0],pos[1]);
                break;
            }
            case SettingsProvider.WSunset:
            {
                drawSunsetSunrise(dc, pos[0],pos[1]);
                break;
            }
            case SettingsProvider.WTime:
            {
                drawTimeString(dc,pos[0],pos[1]);
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

        var clockTime = System.getClockTime();

        var quarter1 = getScreenRelevantSize(0.25);
        var quarter2 = getScreenRelevantSize(0.75);
        var half = getScreenRelevantSize(0.5);

        drawBackground(dc);

        var topPosition = [half, quarter1];
        var bottomPosition = [half,quarter2];
        var leftPosition = [quarter1, half];
        var rightPosition = [quarter2, half];
        drawWidgetByName(dc,_settings.getWidgetTop(_isAwake),topPosition);
        drawWidgetByName(dc,_settings.getWidgetBottom(_isAwake),bottomPosition);
        drawWidgetByName(dc,_settings.getWidgetLeft(_isAwake),leftPosition);
        drawWidgetByName(dc,_settings.getWidgetRight(_isAwake),rightPosition);

        _watchHands[:hour_hand].render(dc);
        _watchHands[:minute_hand].render(dc);
        if(_settings.getShowSeconds(_isAwake))
        {
            _watchHands[:second_hand].render(dc);
        }
        if(_settings.getFaceWatch(_isAwake)== SettingsProvider.FHandsDigits)
        {
            var hCoords = _watchHands[:hour_hand].getHandCaptionCoordinates(half-45);
            var mCoords = _watchHands[:minute_hand].getHandCaptionCoordinates(half-25);
            var alignment = Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_CENTER;
            dc.setColor(_settings.getSecondaryColor(), Graphics.COLOR_TRANSPARENT);
            dc.drawText(hCoords[0],hCoords[1],_font,System.getClockTime().hour.format("%02d"), alignment);
            dc.drawText(mCoords[0],mCoords[1],_font,System.getClockTime().min.format("%02d"), alignment);
        }

        drawArbor(dc);
        drawBattery(dc);
    }

    private function drawDateString(dc as Dc, x as Number, y as Number) as Void {
        var info = Gregorian.info(Time.now(), Time.FORMAT_LONG);
        var dateStr = Lang.format("$1$ $2$", [info.day_of_week.toUpper(), info.day]);

        dc.setColor(_settings.getPrimaryColor(_isAwake), Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, _font, dateStr, Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function drawTimeString(dc as Dc, x as Number, y as Number) as Void {
        var info = Gregorian.info(Time.now(), Time.FORMAT_LONG);
        var timeStr = Lang.format("$1$.$2$", [info.hour.format("%02d"), info.min.format("%02d")]);

        dc.setColor(_settings.getPrimaryColor(_isAwake), Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, _font, timeStr, Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function drawArbor(dc as Dc) as Void
    {
        var x = _screenCenterPoint[0];
        var y = _screenCenterPoint[1];
        var arborSize = 7;
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillCircle(x, y, arborSize);
        dc.setColor(_settings.getArborColor(_isAwake),Graphics.COLOR_BLACK);
        dc.drawCircle(x, y, arborSize);
    }

    private function drawBattery(dc as Dc)
    {
        if(_settings.getShowBatteryArc(_isAwake))
        {
            var cX = _screenCenterPoint[0];
            var cY = _screenCenterPoint[1];
            var batteryValue = ((System.getSystemStats().battery + 0.5)/100);
            var startAngle = 90;
            var endAngle = startAngle - 360 * batteryValue;
            var penWidth = 2;
            dc.setColor(_settings.getPrimaryColor(_isAwake), Graphics.COLOR_TRANSPARENT);
            dc.setPenWidth(penWidth);
            dc.drawArc(cX,cY,getScreenRelevantSize(0.5) - penWidth,Graphics.ARC_CLOCKWISE, startAngle, endAngle);
        }
        if(_settings.getShowDaysRemained(_isAwake))
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

    private function drawSunsetSunrise(dc as Dc, x as Number, y as Number) as Void {

        var conditions = Weather.getCurrentConditions();
        if(conditions == null || conditions.observationLocationPosition == null)
        {
            return;
        }

        var sunEventInfo = _weatherProvider.getNextSunEvent(conditions);
        var eventTypeDict = {WeatherProvider.Sunrise => "r", WeatherProvider.Sunset => "s"};
        var dataString = sunEventInfo[:timeInfo].hour.format("%02d")+"."+sunEventInfo[:timeInfo].min.format("%02d");
        dc.drawText(x,y,_font, dataString, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(x,y-70,_weatherFont, eventTypeDict.get(sunEventInfo[:eventType]), Graphics.TEXT_JUSTIFY_CENTER);        
    }

    private function drawWeatherWidget(dc as Dc, x as Number, y as Number) as Void
    {
        var conditions = Weather.getCurrentConditions();
        if(conditions == null || conditions.observationLocationPosition == null
           || conditions.condition == null || conditions.temperature == null)
        {
            return;
        }
        var resultString = _weatherProvider.matchWeatherSymbol(conditions);
        dc.setColor(_settings.getSecondaryColor(), Graphics.COLOR_TRANSPARENT);
        dc.drawText(x,y,Graphics.FONT_SYSTEM_XTINY,conditions.temperature.toString()+"°C",Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(x,y-95,_weatherFont, resultString, Graphics.TEXT_JUSTIFY_CENTER); 
    }

    private function drawBackground(dc as Dc) as Void {
        if(_settings.getFaceWatch(_isAwake) == SettingsProvider.FStandard)
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
