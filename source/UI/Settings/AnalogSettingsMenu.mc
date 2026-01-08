using Rez.Strings as Str;

import Toybox.Lang;
import Toybox.WatchUi;


class AnalogSettingsMenu extends WatchUi.Menu2 {

    public function initialize() {
        Menu2.initialize({:title=>WatchUi.loadResource(Str.Settings)});
    }
}

class AnalogSettingsMenuDelegate extends WatchUi.Menu2InputDelegate {

    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    public function createToggle(stringId as Symbol, defaultValue as Boolean)
    {
        var configId = Helpers.configMapping[stringId];
        return new WatchUi.ToggleMenuItem(
            WatchUi.loadResource(stringId),
            null,
            stringId,
            SettingsProvider.getInstance().getOption(configId, defaultValue),
            null);
    }

    public function onSelect(menuItem as MenuItem) as Void {
        $.gSettingsChanged = true;
        var id = menuItem.getId() as String;

        var settings = SettingsProvider.getInstance();
        var isAwake = (id == Str.AwakeTitle);
        var isAon = (id == Str.AlwaysOnTitle);
        if(isAwake || isAon)
        {
            var menuTitle = WatchUi.loadResource(isAwake ? Str.AwakeTitle : Str.AlwaysOnTitle);
            var menu = new WatchUi.Menu2({:title=> menuTitle});
            if(isAwake)
            {
                var drawable = new $.SettingsColorIcon(settings.getOption(Helpers.configMapping[Str.PrimaryColor], true));
                menu.addItem(new WatchUi.IconMenuItem(WatchUi.loadResource(Str.PrimaryColor), 
                                                      WatchUi.loadResource(drawable.getString()),
                Str.PrimaryColor, drawable, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT}));
            }
            var stringName = settings.getOption(Helpers.configMapping[Str.WatchFace], isAwake);
            var subhead = Helpers.watchFacesMapping[stringName];
            menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Str.WatchFace), subhead, Str.WatchFace, null));
            menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Str.Widgets), null, Str.Widgets, null));
            menu.addItem(createToggle(Str.ShowBatteryArc, isAwake));

            if(isAwake)
            {
                menu.addItem(createToggle(Str.ShowSeconds, true));
                menu.addItem(createToggle(Str.ShowDaysRemained, true));
            }
            WatchUi.pushView(menu, new $.SubMenuDelegate(isAwake), WatchUi.SLIDE_UP);
        }
    }
}

