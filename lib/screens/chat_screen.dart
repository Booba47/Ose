import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import '../models/dating_profile.dart';
import '../services/block_service.dart';
import '../services/message_service.dart';
import '../services/report_service.dart';
import '../services/unread_message_service.dart';

class ChatScreen extends StatefulWidget {
  final DatingProfile profile;

  const ChatScreen({
    super.key,
    required this.profile,
  });

  @override
  State<ChatScreen> createState() =>
      _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController =
      TextEditingController();

  final ScrollController _scrollController =
      ScrollController();

  late List<ChatMessage> _messages;

  bool _isBlocked = false;

  @override
  void initState() {
    super.initState();

    _isBlocked =
        BlockService.isBlocked(widget.profile);

    _loadMessages();

    // Marque les messages comme lus
    UnreadMessageService.markAsRead(
      widget.profile,
    );

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _scrollToBottom();
      },
    );
  }

  void _loadMessages() {
    _messages =
        MessageService.getMessages(
      widget.profile,
    );
  }

  Future<void> _sendMessage() async {
    final text =
        _messageController.text.trim();

    if (text.isEmpty || _isBlocked) {
      return;
    }

    await MessageService.sendMessage(
      profile: widget.profile,
      message: text,
    );

    // Met à jour le compteur
    UnreadMessageService.sync(
      widget.profile,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _loadMessages();
    });

    _messageController.clear();

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance
        .addPostFrameCallback(
      (_) {
        if (!_scrollController.hasClients) {
          return;
        }

        _scrollController.animateTo(
          _scrollController
              .position
              .maxScrollExtent,
          duration:
              const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      },
    );
  }

  @override
  void dispose() {
    UnreadMessageService.sync(
      widget.profile,
    );

    _messageController.dispose();
    _scrollController.dispose();

    super.dispose();
  }
    String _formatTime(DateTime dateTime) {
    final hour =
        dateTime.hour.toString().padLeft(2, '0');

    final minute =
        dateTime.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  void _showOptions() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            25,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFDDDDDD),
                  borderRadius:
                      BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Options',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 15),

              _OptionTile(
                icon: Icons.delete_outline,
                title:
                    'Supprimer la conversation',
                onTap: () {
                  Navigator.pop(context);
                  _confirmDeleteConversation();
                },
              ),

              _OptionTile(
                icon: Icons.block_outlined,
                title:
                    'Bloquer cette personne',
                color:
                    const Color(0xFFC62861),
                onTap: () {
                  Navigator.pop(context);
                  _confirmBlock();
                },
              ),

              _OptionTile(
                icon: Icons.flag_outlined,
                title:
                    'Signaler',
                color:
                    const Color(0xFFC62861),
                onTap: () {
                  Navigator.pop(context);
                  _showReportDialog();
                },
              ),
            ],
          ),
        );
      },
    );
  }


  void _confirmDeleteConversation() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Supprimer la conversation ?',
            style: TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),

          content: Text(
            'Les messages avec ${widget.profile.name} seront supprimés.',
          ),

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(24),
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  const Text('Annuler'),
            ),

            ElevatedButton(
              onPressed: () async {

                Navigator.pop(context);

                await MessageService
                    .deleteConversation(
                  widget.profile,
                );

                await UnreadMessageService
                    .markAsRead(
                  widget.profile,
                );

                if (!mounted) {
                  return;
                }

                Navigator.pop(context);

              },

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFFED1767),
                foregroundColor:
                    Colors.white,
              ),

              child:
                  const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }
    void _confirmBlock() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Bloquer cette personne ?',
            style: TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
          content: Text(
            '${widget.profile.name} ne pourra plus apparaître dans tes conversations.',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),

            ElevatedButton(
              onPressed: () async {

                Navigator.pop(context);

                await BlockService.blockProfile(
                  widget.profile,
                );

                await MessageService
                    .deleteConversation(
                  widget.profile,
                );

                await UnreadMessageService
                    .markAsRead(
                  widget.profile,
                );

                if (!mounted) {
                  return;
                }

                setState(() {
                  _isBlocked = true;
                  _messages = [];
                });

              },

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFFD32F2F),
                foregroundColor:
                    Colors.white,
              ),

              child:
                  const Text('Bloquer'),
            ),
          ],
        );
      },
    );
  }


  void _showReportDialog() {

    final controller =
        TextEditingController();

    showDialog<void>(
      context: context,
      builder: (context) {

        return AlertDialog(
          title: const Text(
            'Signaler ce profil',
            style: TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),

          content: TextField(
            controller: controller,
            maxLines: 4,
            decoration: InputDecoration(
              hintText:
                  'Motif du signalement',
              filled: true,
              fillColor:
                  const Color(0xFFF7F7F7),
              border:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(16),
                borderSide:
                    BorderSide.none,
              ),
            ),
          ),

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(24),
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  const Text('Annuler'),
            ),

            ElevatedButton(
              onPressed: () async {

                final reason =
                    controller.text.trim();

                if (reason.isEmpty) {
                  return;
                }

                await ReportService
                    .reportProfile(
                  profileId:
                      widget.profile.id,
                  reason:
                      reason,
                );

                controller.dispose();

                if (!mounted) {
                  return;
                }

                Navigator.pop(context);

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Signalement envoyé.',
                    ),
                  ),
                );
              },

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFFC62861),
                foregroundColor:
                    Colors.white,
              ),

              child:
                  const Text('Signaler'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFFFFF8FB),

      appBar: AppBar(
        backgroundColor:
            Colors.white,
        elevation: 0,

        title: Row(
          children: [

            Text(
              widget.profile.emoji,
              style:
                  const TextStyle(
                fontSize: 28,
              ),
            ),

            const SizedBox(width: 10),

            Text(
              widget.profile.name,
              style:
                  const TextStyle(
                color: Colors.black,
                fontWeight:
                    FontWeight.w900,
              ),
            ),
          ],
        ),

        actions: [

          IconButton(
            icon:
                const Icon(
              Icons.more_vert,
              color:
                  Colors.black,
            ),
            onPressed:
                _showOptions,
          ),

        ],
      ),


      body: _isBlocked
          ? const Center(
              child: Text(
                'Cette personne est bloquée.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            )

          : Column(
              children: [

                Expanded(
                  child:
                      ListView.builder(
                    controller:
                        _scrollController,

                    padding:
                        const EdgeInsets.all(16),

                    itemCount:
                        _messages.length,

                    itemBuilder:
                        (context,index){

                      final message =
                          _messages[index];

                      return _MessageBubble(
                        message:
                            message,

                        time:
                            _formatTime(
                          message.sentAt,
                        ),
                      );
                    },
                  ),
                ),


                SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(12),

                    child: Row(
                      children: [

                        Expanded(
                          child:
                              TextField(
                            controller:
                                _messageController,

                            decoration:
                                InputDecoration(
                              hintText:
                                  'Écris un message...',
                              filled:
                                  true,
                              fillColor:
                                  Colors.white,
                              border:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(25),
                                borderSide:
                                    BorderSide.none,
                              ),
                            ),
                          ),
                        ),


                        const SizedBox(width:8),


                        FloatingActionButton(
                          mini:
                              true,

                          backgroundColor:
                              const Color(0xFFED1767),

                          onPressed:
                              _sendMessage,

                          child:
                              const Icon(
                            Icons.send,
                            color:
                                Colors.white,
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
class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final String time;

  const _MessageBubble({
    required this.message,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {

    final isMine = message.isMine;

    return Align(
      alignment: isMine
          ? Alignment.centerRight
          : Alignment.centerLeft,

      child: Container(
        margin:
            const EdgeInsets.only(bottom: 12),

        padding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),

        constraints:
            BoxConstraints(
          maxWidth:
              MediaQuery.of(context)
                      .size
                      .width *
                  0.75,
        ),

        decoration: BoxDecoration(

          color: isMine
              ? const Color(0xFFED1767)
              : Colors.white,

          borderRadius:
              BorderRadius.circular(22),

          boxShadow: const [
            BoxShadow(
              color:
                  Color(0x12000000),
              blurRadius: 8,
              offset:
                  Offset(0,3),
            ),
          ],
        ),


        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.end,

          children: [

            Text(
              message.text,

              style: TextStyle(
                color: isMine
                    ? Colors.white
                    : Colors.black87,

                fontSize: 15,
              ),
            ),


            const SizedBox(height:5),


            Text(
              time,

              style: TextStyle(
                fontSize: 10,

                color: isMine
                    ? Colors.white70
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class _OptionTile extends StatelessWidget {

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color color;


  const _OptionTile({

    required this.icon,
    required this.title,
    required this.onTap,

    this.color =
        const Color(0xFF555555),

  });


  @override
  Widget build(BuildContext context) {

    return ListTile(

      leading:
          Icon(
        icon,
        color:
            color,
      ),


      title:
          Text(
        title,

        style:
            TextStyle(
          color:
              color,

          fontWeight:
              FontWeight.w700,
        ),
      ),


      onTap:
          onTap,
    );
  }
} 
