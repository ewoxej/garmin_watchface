import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

class SettingsColorIcon extends WatchUi.Drawable {

    private const _colors = [Graphics.COLOR_RED, Graphics.COLOR_ORANGE, Graphics.COLOR_YELLOW, Graphics.COLOR_GREEN,
                             Graphics.COLOR_BLUE, Graphics.COLOR_PURPLE] as Array<Number>;
    private const _colorStrings = ["Red", "Orange", "Yellow", "Green", "Blue", "Violet"] as Array<String>;
    private var _index as Number;

    public function initialize(oldColor as Number) {
        Drawable.initialize({});
        _index = _colors.indexOf(oldColor as Number);
    }

    public function nextState() as String {
        _index++;
        if (_index >= _colors.size()) {
            _index = 0;
        }

        return _colorStrings[_index];
    }

    public function getString() as String {
        return _colorStrings[_index];
    }

    public function getValue() as Number
    {
        return _colors[_index];
    }

    public function draw(dc as Dc) as Void {
        var color = _colors[_index];
        dc.setColor(color, color);
        dc.fillCircle(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()/2);
    }
}