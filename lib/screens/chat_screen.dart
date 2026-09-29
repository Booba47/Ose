import 'package:flutter/material.dart';

import '../models/dating_profile.dart';

class ChatScreen extends StatefulWidget {
  final DatingProfile profile;

  const ChatScreen({
    super.key,
    required this.profile,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController =
      TextEditingController();

  final List<String> _messages = [
    'Salut 😊',
    'Content(e) de faire ta connaissance !',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();

    if (message.isEmpty) {
      return;
    }

    setState(() {
      _messages.add(message);
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  widget.profile.emoji,
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.profile.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Match ❤️',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final isMine = index ==
                    _messages.length - 1;

                return Align(
                  alignment: isMine
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 11,
                    ),
                    constraints: const BoxConstraints(
                      maxWidth: 290,
                    ),
                    decoration: BoxDecoration(
                      color: isMine
                          ? Colors.pink
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _messages[index],
                      style: TextStyle(
                        color: isMine
                            ? Colors.white
                            : Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                12,
                8,
                12,
                12,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      textInputAction:
                          TextInputAction.send,
                      onSubmitted: (_) {
                        _sendMessage();
                      },
                      decoration: InputDecoration(
                        hintText: 'Écris un message...',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  SizedBox(
                    width: 50,
                    height: 50,
                    child: FloatingActionButton(
                      heroTag: 'send_message',
                      onPressed: _sendMessage,
                      backgroundColor: Colors.pink,
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
