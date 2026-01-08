using Toybox.Application as App;
using Toybox.Graphics as G;

import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class WatchFaceView {
    private enum {ShowDigitsNearHands, ShowDigitsCenter, DontShowDigits}

    private var _font as FontResource?;
    private var _screenCenterPoint as Array<Number>?;
    private var _watchHands as Dictionary?;
    private var _screenWidth as Number?;

    public function initialize(fontRes as FontResource) {
        _font = fontRes;
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

    public function onLayout(dc as G.Dc, secondaryColor as Number) as Void {
        _screenCenterPoint = [dc.getWidth() / 2, dc.getHeight() / 2] as Array<Number>;
        _screenWidth = dc.getWidth();

        var baseHandConfig =
        {
            :centerPoint => _screenCenterPoint,
            :tailLength => 20,
            :enableShadow => true,
            :color => secondaryColor
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
        secondHandConfig.put(:color,G.COLOR_RED);
        secondHandConfig.remove(:enableShadow);
        secondHandConfig.put(:handLength,getScreenRelevantSize(0.48));

        _watchHands = {:hour_hand => new WatchHand(hourHandConfig), 
                       :minute_hand => new WatchHand(minuteHandConfig),
                       :second_hand => new WatchHand(secondHandConfig)};
    }

    public function draw(dc as G.Dc, showSeconds as Boolean,
     watchFace as Number, secondaryColor as Number, arborColor as Number) as Void {

        var clockTime = System.getClockTime();

        var quarter1 = getScreenRelevantSize(0.25);
        var quarter2 = getScreenRelevantSize(0.75);
        var half = getScreenRelevantSize(0.5);

        _watchHands[:hour_hand].render(dc);
        _watchHands[:minute_hand].render(dc);
        if(showSeconds)
        {
            _watchHands[:second_hand].render(dc);
        }
        if(watchFace == SettingsProvider.FHandsDigits)
        {
            var hCoords = _watchHands[:hour_hand].getHandCaptionCoordinates(half-45);
            var mCoords = _watchHands[:minute_hand].getHandCaptionCoordinates(half-25);
            var alignment = G.TEXT_JUSTIFY_VCENTER | G.TEXT_JUSTIFY_CENTER;
            dc.setColor(secondaryColor, G.COLOR_TRANSPARENT);
            dc.drawText(hCoords[0],hCoords[1],_font,System.getClockTime().hour.format("%02d"), alignment);
            dc.drawText(mCoords[0],mCoords[1],_font,System.getClockTime().min.format("%02d"), alignment);
        }

        drawArbor(dc, arborColor);
    }

    private function drawArbor(dc as G.Dc, arborColor as Number) as Void
    {
        var x = _screenCenterPoint[0];
        var y = _screenCenterPoint[1];
        var arborSize = 7;
        dc.setColor(G.COLOR_BLACK, G.COLOR_BLACK);
        dc.fillCircle(x, y, arborSize);
        dc.setColor(arborColor, G.COLOR_BLACK);
        dc.drawCircle(x, y, arborSize);
    }
}
