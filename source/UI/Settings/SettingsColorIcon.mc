using Rez.Strings as Str;

import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

class SettingsColorIcon extends WatchUi.Drawable {
    private const _colorDict = {
        Graphics.COLOR_RED => Str.ColorRed,
        Graphics.COLOR_ORANGE => Str.ColorOrange,
        Graphics.COLOR_YELLOW => Str.ColorYellow,
        Graphics.COLOR_GREEN => Str.ColorGreen,
        Graphics.COLOR_BLUE => Str.ColorBlue,
        Graphics.COLOR_PURPLE  => Str.ColorViolet
    };

    private var _selectedColor as Number;

    public function initialize(oldColor as Number) {
        Drawable.initialize({});
        _selectedColor = oldColor;
    }

    public function nextState() as Symbol {
        var currentIndex = _colorDict.keys().indexOf(_selectedColor);
        currentIndex++;
        if (currentIndex >= _colorDict.size()) {
            currentIndex = 0;
        }
        _selectedColor = _colorDict.keys()[currentIndex] as Number;

        return _colorDict[_selectedColor];
    }

    public function getString() as Symbol {
        return _colorDict[_selectedColor];
    }

    public function getValue() as Number
    {
        return _selectedColor;
    }

    public function draw(dc as Dc) as Void {
        dc.setColor(_selectedColor, _selectedColor);
        dc.fillCircle(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()/2);
    }
}