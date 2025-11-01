import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:webview_flutter/webview_flutter.dart';
import 'web_iframe.dart';
import '../localization/app_localizations.dart';


class ChatBotDialog extends StatefulWidget {
  const ChatBotDialog({super.key});

  @override
  State<ChatBotDialog> createState() => _ChatBotDialogState();
}

class _ChatBotDialogState extends State<ChatBotDialog> {
  late final WebViewController? controller;
  bool isLoading = true;
  final String chatbotUrl = 'https://app.chatgptbuilder.io/webchat/?p=1596929&ref=1725999534068';
  String? _iframeViewType;
  
  @override
  void initState() {
    super.initState();
    
    if (kIsWeb) {
      // For web, create an iframe
      _iframeViewType = 'iframe-view-type-${DateTime.now().millisecondsSinceEpoch}';
      registerIframeView(_iframeViewType!, chatbotUrl);
      controller = null;
      isLoading = false;
    } else {
      // For mobile, use WebView
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              if (progress == 100) {
                setState(() {
                  isLoading = false;
                });
              }
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {
              setState(() {
                isLoading = false;
              });
            },
            onWebResourceError: (WebResourceError error) {},
          ),
        )
        ..loadRequest(Uri.parse(chatbotUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      elevation: 0,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.smart_toy, color: Colors.blue),
                        radius: 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context).chatAssistant,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                child: kIsWeb && _iframeViewType != null
                    ? HtmlElementView(viewType: _iframeViewType!)
                    : Stack(
                        children: [
                          if (controller != null) WebViewWidget(controller: controller!),
                          if (isLoading)
                            const Center(
                              child: CircularProgressIndicator(),
                            ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 