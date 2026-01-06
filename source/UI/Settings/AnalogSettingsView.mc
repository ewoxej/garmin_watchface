
import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class AnalogSettingsView extends WatchUi.View {

    public function initialize() {
        View.initialize();
    }

    public function onLayout(dc as Dc)
    {
        var menu = new $.AnalogSettingsMenu();
        menu.addItem(new WatchUi.MenuItem("Awake", null, Helpers.OptionAwake, null));
        menu.addItem(new WatchUi.MenuItem("Always on Mode", null, Helpers.OptionAlwaysOn, null));

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
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }

    public function onDone() as Boolean{
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
}

