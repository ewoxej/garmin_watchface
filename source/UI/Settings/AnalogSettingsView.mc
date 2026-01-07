import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
using Rez.Strings as Str;

class AnalogSettingsView extends WatchUi.View {

    public function initialize() {
        View.initialize();
    }

    public function onLayout(dc as Dc)
    {
        var menu = new $.AnalogSettingsMenu();
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Str.AwakeTitle), null, Str.AwakeTitle, null));
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Str.AlwaysOnTitle), null, Str.AlwaysOnTitle, null));

        WatchUi.pushView(menu, new $.AnalogSettingsMenuDelegate(), WatchUi.SLIDE_IMMEDIATE);
    }
}

class AnalogSettingsDelegate extends WatchUi.BehaviorDelegate {

    //! Constructor
    public function initialize() {
        BehaviorDelegate.initialize();
    }

    public function onMenu() as Boolean {
        return true;
    }
    public function onBack() as Boolean{
        return onDone();
    }

    public function onDone() as Boolean{
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
}

