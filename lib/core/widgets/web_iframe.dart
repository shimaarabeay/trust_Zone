// This file provides platform-specific implementation for web iframes
// using conditional imports

import 'web_iframe_web.dart' if (dart.library.io) 'web_iframe_mobile.dart';
 
/// Register an HTML iframe element for use in a Flutter HtmlElementView
/// This method automatically handles platform differences
void registerIframeView(String viewType, String url) {
  createIframeView(viewType, url);
} 