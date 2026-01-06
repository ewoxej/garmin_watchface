import Toybox.Lang;
import Toybox.WatchUi;

class SubMenuDelegate extends WatchUi.Menu2InputDelegate {

        private var _settings as SettingsProvider;
        private var _isAwake as Boolean;

        public function initialize(isAwake as Boolean)
        {
            Menu2InputDelegate.initialize();
            _settings = SettingsProvider.getInstance();
            _isAwake = isAwake;
        }

        public function onSelect(item as MenuItem) as Void 
        {
            var id = item.getId() as Number;
            switch(id)
            {
            case Helpers.OptionPrimaryColor:
            {
                if (item instanceof WatchUi.IconMenuItem) {
                    var customIcon = (item.getIcon() as SettingsColorIcon);
                    item.setSubLabel(customIcon.nextState());
                    _settings.setOption(_isAwake, "primary_color", customIcon.getValue());
                    WatchUi.requestUpdate();
                }
                break;
            }
            case Helpers.OptionWatchFace:
            {
                var newValue = _settings.nextOption("face_watch", _isAwake);
                item.setSubLabel(Helpers.getWatchFaceStringValue(newValue));
                break;
            }
            case Helpers.OptionWidgets:
            {
                var menu = new WatchUi.Menu2({:title=>"Widgets"});
                menu.addItem(new WatchUi.MenuItem("Top widget", Helpers.getWidgetStringValue(_settings.getOption("wgt_top", _isAwake)), Helpers.OptionWTop, null));
                menu.addItem(new WatchUi.MenuItem("Bottom widget", Helpers.getWidgetStringValue(_settings.getOption("wgt_bottom", _isAwake)), Helpers.OptionWBottom, null));
                menu.addItem(new WatchUi.MenuItem("Left widget", Helpers.getWidgetStringValue(_settings.getOption("wgt_left", _isAwake)), Helpers.OptionWLeft, null));
                menu.addItem(new WatchUi.MenuItem("Right widget", Helpers.getWidgetStringValue(_settings.getOption("wgt_right", _isAwake)), Helpers.OptionWRight, null));
                WatchUi.pushView(menu, new $.SubMenuDelegate(_isAwake), WatchUi.SLIDE_UP);
                break;
            }
            case Helpers.OptionShowSeconds:
            {
                _settings.setOption(true, "seconds",(item as ToggleMenuItem).isEnabled());
                break;
            }
            case Helpers.OptionBatteryArc:
            {
                _settings.setOption(_isAwake, "battery_arc", (item as ToggleMenuItem).isEnabled());
                break;
            }
            case Helpers.OptionBatteryDays:
            {
                _settings.setOption(true, "battery_days", (item as ToggleMenuItem).isEnabled());
                break;
            }
            case Helpers.OptionWTop:
            {
                var newValue = _settings.nextOption("wgt_top", _isAwake);
                item.setSubLabel(Helpers.getWidgetStringValue(newValue));
                break;
            }
            case Helpers.OptionWBottom:
            {
                var newValue = _settings.nextOption("wgt_bottom", _isAwake);
                item.setSubLabel(Helpers.getWidgetStringValue(newValue));
                break;
            }
            case Helpers.OptionWLeft:
            {
                var newValue = _settings.nextOption("wgt_left", _isAwake);
                item.setSubLabel(Helpers.getWidgetStringValue(newValue));
                break;
            }
            case Helpers.OptionWRight:
            {
                var newValue = _settings.nextOption("wgt_right", _isAwake);
                item.setSubLabel(Helpers.getWidgetStringValue(newValue));
                break;
            }
            }
        }
        
    public function onBack() as Void {
        _settings.saveSettings();
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    public function onDone() as Void {
        _settings.saveSettings();
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}