using Toybox.Graphics as G;
import Toybox.Lang;


class BatteryView
{
    private var _screenCenterPoint as Array<Number>;
    private var _color as Number;
    private var _screenWidth as Number;

    public function initialize(dc as G.Dc, color as Number)
    {
        _screenCenterPoint = [dc.getWidth() / 2, dc.getHeight() / 2] as Array<Number>;
        _color = color;
        _screenWidth = dc.getWidth();
    }

    public function updateColor(color as Number)
    {
        _color = color;
    }
    public function draw(dc as G.Dc, showBatteryArc as Boolean, showDaysRemained as Boolean)
    {
        if(showBatteryArc)
        {
            var cX = _screenCenterPoint[0];
            var cY = _screenCenterPoint[1];
            var batteryValue = ((System.getSystemStats().battery + 0.5)/100);
            var startAngle = 90;
            var endAngle = startAngle - 360 * batteryValue;
            var penWidth = 2;
            dc.setColor(_color, Graphics.COLOR_TRANSPARENT);
            dc.setPenWidth(penWidth);
            dc.drawArc(cX,cY,(_screenWidth * 0.5).toNumber() - penWidth,Graphics.ARC_CLOCKWISE, startAngle, endAngle);
        }
        if(showDaysRemained)
        {
            var value = System.getSystemStats().batteryInDays.toNumber();
            var angle = (value * 6) * (Math.PI/180);
            var cos = Math.cos(angle);
            var sin = Math.sin(angle);
            var length = (_screenWidth * 0.45).toNumber();
            var x = (cos-(-length)*sin+0.5) + _screenCenterPoint[0];
            var y = (sin+(-length)*cos+0.5) + _screenCenterPoint[1];
            dc.fillCircle(x, y, 3);
        }
    }
}