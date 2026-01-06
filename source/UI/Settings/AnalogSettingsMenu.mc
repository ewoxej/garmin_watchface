import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class AnalogSettingsMenu extends WatchUi.Menu2 {

    public function initialize() {
        Menu2.initialize({:title=>"Settings"});
    }
}

class AnalogSettingsMenuDelegate extends WatchUi.Menu2InputDelegate {

    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    public function onSelect(menuItem as MenuItem) as Void {
        $.gSettingsChanged = true;
        var id = menuItem.getId() as String;

        var settings = SettingsProvider.getInstance();
        if(id == Helpers.OptionAwake)
        {
            var menu = new WatchUi.Menu2({:title=>"Awake"});
            var drawable = new $.SettingsColorIcon(settings.getOption("primary_color", true));
            menu.addItem(new WatchUi.IconMenuItem("Primary Color", drawable.getString(),
            Helpers.OptionPrimaryColor, drawable, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT}));
            menu.addItem(new WatchUi.MenuItem("Face watch style", Helpers.getWatchFaceStringValue(settings.getOption("face_watch", true)), Helpers.OptionWatchFace, null));
            menu.addItem(new WatchUi.MenuItem("Widgets", null, Helpers.OptionWidgets, null));
            menu.addItem(new WatchUi.ToggleMenuItem("Show seconds", null, Helpers.OptionShowSeconds, settings.getOption("seconds", true), null));
            menu.addItem(new WatchUi.ToggleMenuItem("Show battery arc", null, Helpers.OptionBatteryArc, settings.getOption("battery_arc", true), null));
            menu.addItem(new WatchUi.ToggleMenuItem("Show days remained", null, Helpers.OptionBatteryDays, settings.getOption("battery_days", true), null));
            WatchUi.pushView(menu, new $.SubMenuDelegate(true), WatchUi.SLIDE_UP);
        }
        else if(id == Helpers.OptionAlwaysOn)
        {
            var menu = new WatchUi.Menu2({:title=>"Always on"});
            menu.addItem(new WatchUi.MenuItem("Face watch style", Helpers.getWatchFaceStringValue(settings.getOption("face_watch", false)), Helpers.OptionWatchFace, null));
            menu.addItem(new WatchUi.MenuItem("Widgets", null, Helpers.OptionWidgets, null));
            menu.addItem(new WatchUi.ToggleMenuItem("Show battery arc", null, Helpers.OptionBatteryArc, settings.getOption("battery_arc", false), null));
            WatchUi.pushView(menu, new $.SubMenuDelegate(false), WatchUi.SLIDE_UP);
        }
    }
}

