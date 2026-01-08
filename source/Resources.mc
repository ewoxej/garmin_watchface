using Toybox.Application as App;
using Rez.Strings as Str;

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class Resources {
    public var font as FontResource?;
    public var weatherFont as FontResource?;
    public var faceBitmap as BitmapResource?;
    public var logo as BitmapResource?;

    public function initialize(font_arg as FontResource, weatherFont_arg as FontResource,
                               faceBitmap_arg as BitmapResource, logo_arg as BitmapResource) {
        font = font_arg;
        weatherFont = weatherFont_arg;
        faceBitmap = faceBitmap_arg;
        logo = logo_arg;
    }
}
