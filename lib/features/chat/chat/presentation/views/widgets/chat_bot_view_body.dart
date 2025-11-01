import 'package:flutter/material.dart';
import 'dart:io';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

class ChatBotViewBody extends StatefulWidget {
  const ChatBotViewBody({super.key});

  @override
  State<ChatBotViewBody> createState() => _ChatBotViewBodyState();
}

class _ChatBotViewBodyState extends State<ChatBotViewBody> {
  late final WebViewController? controller;
  bool isLoading = true;
  final String chatbotUrl = 'https://app.chatgptbuilder.io/webchat/?p=1596929&u=1000113746&c=22477059&ref=1725999534068';

  @override
  void initState() {
    super.initState();
    // Only initialize the WebViewController on mobile platforms
    if (!kIsWeb) {
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
    } else {
      controller = null;
      // For web, we'll use a button to open the URL in a new tab
      isLoading = false;
    }
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(Uri.parse(chatbotUrl), mode: LaunchMode.externalApplication)) {
      // Show error if URL launch fails
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch chatbot')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.teal,
              child: Icon(Icons.smart_toy, color: Colors.white),
              radius: 18,
            ),
            SizedBox(width: 10),
            Text(
              'Chat Assistant',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: kIsWeb 
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Click the button below to open the chatbot in a new tab',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _launchUrl,
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Launch Chat Assistant'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                if (controller != null) WebViewWidget(controller: controller!),
                if (isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
    );
  }
}
