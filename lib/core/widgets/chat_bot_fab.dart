import 'package:flutter/material.dart';

import 'chat_bot_dialog.dart';


/// A floating action button that opens the ChatBot dialog when pressed.
class ChatBotFAB extends StatelessWidget {
  const ChatBotFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => const ChatBotDialog(),
        );
      },
      backgroundColor: Colors.blue,
      elevation: 4,
      tooltip: 'Chat Assistant',
      child: const Icon(
        Icons.smart_toy,
        color: Colors.white,
      ),
    );
  }
} 