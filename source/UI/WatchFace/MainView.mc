using Toybox.Application as App;
using Rez.Strings as Str;
using Rez.Fonts as Fonts;
using Rez.Drawables as Imgs;

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class MainView extends WatchUi.WatchFace {
    private var _settings as SettingsProvider?;
    private var _res as Resources?;
    private var _isAwake as Boolean;

    private var _watchFace as WatchFaceLayer;
    private var _batteryView as BatteryLayer?;
    private var _widgets as Dictionary;
    private var _widgetPositions as Dictionary?;

    public function initialize() {
        WatchFace.initialize();

        _watchFace = new WatchFaceLayer(WatchUi.loadResource($.Rez.Fonts.ledboard));
        _isAwake = true;
        _widgets = { Str.WidgetPosTop => null, Str.WidgetPosBottom => null,
                     Str.WidgetPosLeft => null, Str.WidgetPosRight => null};
    }

    private function getOpt(key as Symbol)
    {
        var settings = SettingsProvider.getInstance();
        return settings.getOption(Helpers.configMapping[key], _isAwake);
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
        var primaryColor = getOpt(Str.PrimaryColor);

        switch(name)
        {
            case SettingsProvider.WDate:
                return new DateWidget(primaryColor, _res.font);
            case SettingsProvider.WWeather:
                return new WeatherWidget(getOpt(Str.SecondaryColor), _res.weatherFont);
            case SettingsProvider.WSunset:
                return new SunsetSunriseWidget(_res.font, _res.weatherFont);
            case SettingsProvider.WTime:
                return new TimeWidget(primaryColor, _res.font);
            case SettingsProvider.WBrand:
                return new BrandWidget(_res.logo);
        }
        return null;
    }

    public function updateView()
    {
        for(var i = 0; i < _widgets.size(); i++)
        {
            var key = _widgets.keys()[i];
            _widgets[key] = getWidget(getOpt(key as Symbol));
        }

        _batteryView.updateColor(getOpt(Str.PrimaryColor));
    }

    public function onLayout(dc as Dc) as Void {
        _res = new Resources(WatchUi.loadResource(Fonts.ledboard), WatchUi.loadResource(Fonts.WeatherFont),
                             WatchUi.loadResource(Imgs.FaceBitmap), WatchUi.loadResource(Imgs.GarminLogo));
        _settings = SettingsProvider.getInstance();
        _watchFace.onLayout(dc, getOpt(Str.SecondaryColor));
        _batteryView = new BatteryLayer(dc, getOpt(Str.PrimaryColor));

        _widgetPositions = calculateWidgetPositions(dc.getWidth());
        updateView();
    }

    public function onUpdate(dc as Dc) as Void {

        if ($.gSettingsChanged) {
			$.gSettingsChanged = false;
			_settings.retrieveSettings();
            updateView();
		}

        drawBackground(dc, getOpt(Str.WatchFace));

        for(var i = 0; i < _widgets.size(); i++)
        {
            var key = _widgets.keys()[i];
            if(_widgets[key] != null)
            {
                _widgets[key].draw(dc, _widgetPositions[key]);
            }
        }

        _watchFace.draw(dc, getOpt(Str.ShowSeconds), getOpt(Str.WatchFace),
            getOpt(Str.SecondaryColor), _settings.getArborColor(_isAwake));
        _batteryView.draw(dc, getOpt(Str.ShowBatteryArc), getOpt(Str.ShowDaysRemained));
    }

    private function drawBackground(dc as Dc, watchFace as Number) as Void {
        if(watchFace == SettingsProvider.FStandard)
        {
            dc.drawBitmap(0, 0, _res.faceBitmap);
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
