// Web implementation
import 'dart:html' as html;
import 'dart:ui_web' as ui;

/// Creates an iframe on web platforms
void createIframeView(String viewType, String url) {
  // Register the view factory
  ui.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
    final iframe = html.IFrameElement()
      ..src = url
      ..id = 'iframe-$viewId'
      ..style.border = 'none'
      ..style.height = '100%'
      ..style.width = '100%'
      ..style.overflow = 'hidden'
      ..allowFullscreen = true;
      
    return iframe;
  });
} 