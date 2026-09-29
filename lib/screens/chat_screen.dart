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

  final ScrollController _scrollController =
      ScrollController();

  final List<_ChatMessage> _messages = [
    _ChatMessage(
      text: 'Salut 😊',
      isMine: false,
      time: '19:42',
    ),
    _ChatMessage(
      text: 'Content(e) de faire ta connaissance !',
      isMine: false,
      time: '19:43',
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();

    if (message.isEmpty) {
      return;
    }

    final now = TimeOfDay.now();

    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');

    setState(() {
      _messages.add(
        _ChatMessage(
          text: message,
          isMine: true,
          time: '$hour:$minute',
        ),
      );
    });

    _messageController.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 300,
        ),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 43,
                  height: 43,
                  decoration: BoxDecoration(
                    color: Colors.pink.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      widget.profile.emoji,
                      style: const TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 13,
                    height: 13,
                    decoration: BoxDecoration(
                      color: Colors.green.shade500,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.profile.name,
                          overflow:
                              TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      if (widget.profile.verified) ...[
                        const SizedBox(width: 5),
                        Icon(
                          Icons.verified,
                          size: 17,
                          color: Colors.blue.shade600,
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 2),

                  Text(
                    'En ligne',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content: Text(
                    'Les options de conversation seront '
                    'ajoutées prochainement.',
                  ),
                  behavior:
                      SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(
              Icons.more_vert,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(
                16,
                18,
                16,
                18,
              ),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];

                return _MessageBubble(
                  message: message,
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(
              12,
              8,
              12,
              10,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade200,
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      minLines: 1,
                      maxLines: 4,
                      textCapitalization:
                          TextCapitalization.sentences,
                      textInputAction:
                          TextInputAction.send,
                      onSubmitted: (_) {
                        _sendMessage();
                      },
                      decoration: InputDecoration(
                        hintText:
                            'Écris un message...',
                        filled: true,
                        fillColor:
                            Colors.grey.shade100,
                        prefixIcon: const Icon(
                          Icons.chat_bubble_outline,
                          size: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(24),
                          borderSide:
                              BorderSide.none,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Material(
                      color: Colors.pink,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder:
                            const CircleBorder(),
                        onTap: _sendMessage,
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 21,
                        ),
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

class _ChatMessage {
  final String text;
  final bool isMine;
  final String time;

  const _ChatMessage({
    required this.text,
    required this.isMine,
    required this.time,
  });
}

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;

  const _MessageBubble({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMine
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 10,
        ),
        constraints: const BoxConstraints(
          maxWidth: 300,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: message.isMine
              ? Colors.pink
              : Colors.grey.shade100,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(
              message.isMine ? 20 : 5,
            ),
            bottomRight: Radius.circular(
              message.isMine ? 5 : 20,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              message.isMine
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                fontSize: 15,
                height: 1.35,
                color: message.isMine
                    ? Colors.white
                    : Colors.black87,
              ),
            ),

            const SizedBox(height: 4),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.time,
                  style: TextStyle(
                    fontSize: 10,
                    color: message.isMine
                        ? Colors.white70
                        : Colors.grey.shade500,
                  ),
                ),

                if (message.isMine) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.done_all,
                    size: 13,
                    color: Colors.white70,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
