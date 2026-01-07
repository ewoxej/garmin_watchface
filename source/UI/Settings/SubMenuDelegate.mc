import Toybox.Lang;
import Toybox.WatchUi;
using Rez.Strings as Str;

class SubMenuDelegate extends WatchUi.Menu2InputDelegate {

    private var _settings as SettingsProvider;
    private var _isAwake as Boolean;

    public function initialize(isAwake as Boolean)
    {
        Menu2InputDelegate.initialize();
        _settings = SettingsProvider.getInstance();
        _isAwake = isAwake;
    }

    public function newMenu(id as Symbol)
    {
        var stringName = _settings.getOption(Helpers.configMapping[id], _isAwake);
        var subhead = Helpers.widgetsMapping[stringName];
        return new WatchUi.MenuItem(WatchUi.loadResource(id), subhead, id, null);
    }
    
    public function showWidgetsMenu()
    {
        var menu = new WatchUi.Menu2({:title=>WatchUi.loadResource(Str.Widgets)});
        menu.addItem(newMenu(Str.WidgetPosBottom));
        menu.addItem(newMenu(Str.WidgetPosTop));
        menu.addItem(newMenu(Str.WidgetPosLeft));
        menu.addItem(newMenu(Str.WidgetPosRight));
        WatchUi.pushView(menu, new $.SubMenuDelegate(_isAwake), WatchUi.SLIDE_UP);
    }

    public function onSelect(item as MenuItem) as Void 
    {
        var id = item.getId() as Symbol;
        switch(id)
        {
        case Str.PrimaryColor:
        {
            if (item instanceof WatchUi.IconMenuItem) {
                var customIcon = (item.getIcon() as SettingsColorIcon);
                item.setSubLabel(WatchUi.loadResource(customIcon.nextState()));
                _settings.setOption(_isAwake, Helpers.configMapping[Str.PrimaryColor], customIcon.getValue());
                WatchUi.requestUpdate();
            }
            break;
        }
        case Str.Widgets:
        {
            showWidgetsMenu();
            break;
        }
        case Str.ShowSeconds:
        case Str.ShowBatteryArc:
        case Str.ShowDaysRemained:
        {
            _settings.setOption(_isAwake, Helpers.configMapping[id], (item as ToggleMenuItem).isEnabled());
            break;
        }
        case Str.WidgetPosTop:
        case Str.WidgetPosBottom:
        case Str.WidgetPosLeft:
        case Str.WidgetPosRight:
        case Str.WatchFace:
        {
            var newValue = _settings.nextOption(Helpers.configMapping[id], _isAwake);
            var resId = (id == Str.WatchFace) ? Helpers.watchFacesMapping[newValue] : Helpers.widgetsMapping[newValue];
            item.setSubLabel(WatchUi.loadResource(resId));
            break;
        }
        }
    }
    
    public function onBack() as Void {
        onDone();
    }

    public function onDone() as Void {
        _settings.saveSettings();
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}