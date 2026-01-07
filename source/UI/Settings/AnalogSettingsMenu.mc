import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class AnalogSettingsMenu extends WatchUi.Menu2 {

    public function initialize() {
        Menu2.initialize({:title=>WatchUi.loadResource(Rez.Strings.Settings)});
    }
}

class AnalogSettingsMenuDelegate extends WatchUi.Menu2InputDelegate {

    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    public function createToggle(stringId as Symbol, optionId as Number, configId as String, defaultValue as Boolean)
    {
        return new WatchUi.ToggleMenuItem(
            WatchUi.loadResource(stringId),
            null,
            optionId,
            SettingsProvider.getInstance().getOption(configId, defaultValue),
            null);
    }

    public function onSelect(menuItem as MenuItem) as Void {
        $.gSettingsChanged = true;
        var id = menuItem.getId() as String;

        var settings = SettingsProvider.getInstance();
        var isAwake = (id == Helpers.OptionAwake);
        var isAon = (id == Helpers.OptionAlwaysOn);
        if(isAwake || isAon)
        {
            var menuTitle = WatchUi.loadResource(isAwake ? Rez.Strings.AwakeTitle : Rez.Strings.AlwaysOnTitle);
            var menu = new WatchUi.Menu2({:title=> menuTitle});
            if(isAwake)
            {
                var drawable = new $.SettingsColorIcon(settings.getOption("primary_color", true));
                menu.addItem(new WatchUi.IconMenuItem(WatchUi.loadResource(Rez.Strings.PrimaryColor), drawable.getString(),
                Helpers.OptionPrimaryColor, drawable, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT}));
            }
            menu.addItem(new WatchUi.MenuItem(
                WatchUi.loadResource(Rez.Strings.FaceWatchStyle),
                Helpers.getWatchFaceStringValue(settings.getOption("face_watch", isAwake)),
                Helpers.OptionWatchFace, null));
            menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Widgets), null, Helpers.OptionWidgets, null));
            menu.addItem(createToggle(Rez.Strings.ShowBatteryArc, Helpers.OptionBatteryArc, "battery_arc", isAwake));

            if(isAwake)
            {
                menu.addItem(createToggle(Rez.Strings.ShowSeconds, Helpers.OptionShowSeconds, "seconds", true));
                menu.addItem(createToggle(Rez.Strings.ShowDaysRemained, Helpers.OptionBatteryDays, "battery_days", true));
            }
            WatchUi.pushView(menu, new $.SubMenuDelegate(isAwake), WatchUi.SLIDE_UP);
        }
    }
}

