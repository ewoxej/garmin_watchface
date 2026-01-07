import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

class SettingsColorIcon extends WatchUi.Drawable {
    private const _colorDict = {
        Graphics.COLOR_RED => Rez.Strings.ColorRed,
        Graphics.COLOR_ORANGE => Rez.Strings.ColorOrange,
        Graphics.COLOR_YELLOW => Rez.Strings.ColorYellow,
        Graphics.COLOR_GREEN => Rez.Strings.ColorGreen,
        Graphics.COLOR_BLUE => Rez.Strings.ColorBlue,
        Graphics.COLOR_PURPLE  => Rez.Strings.ColorViolet
    };

    private var _selectedColor as Number;

    public function initialize(oldColor as Number) {
        Drawable.initialize({});
        _selectedColor = oldColor;
    }

    public function nextState() as String {
        var currentIndex = _colorDict.keys().indexOf(_selectedColor);
        currentIndex++;
        if (currentIndex >= _colorDict.size()) {
            currentIndex = 0;
        }
        _selectedColor = _colorDict.keys()[currentIndex] as Number;

        return _colorDict[_selectedColor];
    }

    public function getString() as String {
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