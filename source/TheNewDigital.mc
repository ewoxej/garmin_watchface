using Toybox.Application as App;
using Toybox.WatchUi as Ui;
import Toybox.Lang;
import Toybox.WatchUi;

var gDeviceSettings;
var gSettingsChanged = true;

class TheNewDigital extends App.AppBase {

    function initialize() {
        AppBase.initialize();
        $.gDeviceSettings = System.getDeviceSettings();
    }

	function onSettingsChanged() {
		$.gSettingsChanged = true;
		$.gDeviceSettings = System.getDeviceSettings();
		Ui.requestUpdate();
	}
    // onStart() is called on application start up
    function onStart(state) {
        
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new MainView() ];
    }

    function getSettingsView() as Array<Views or InputDelegates>? {
        return [new $.AnalogSettingsView(), new $.AnalogSettingsDelegate()] as Array<Views or InputDelegates>;
    }

}