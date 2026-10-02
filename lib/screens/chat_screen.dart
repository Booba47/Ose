import 'package:flutter/material.dart';

import '../models/dating_profile.dart';
import '../services/block_service.dart';
import '../services/message_service.dart';
import '../services/report_service.dart';

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

  late List<String> _messages;

  // Les messages envoyés pendant cette session
  // sont identifiés comme étant les nôtres.
  final Set<String> _myMessages = {};

  bool _isBlocked = false;

  @override
  void initState() {
    super.initState();

    _isBlocked = BlockService.isBlocked(widget.profile);

    _loadMessages();
  }

  void _loadMessages() {
    _messages = MessageService.getMessages(widget.profile);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();

    if (text.isEmpty || _isBlocked) {
      return;
    }

    await MessageService.sendMessage(
      profile: widget.profile,
      message: text,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _myMessages.add(text);
      _loadMessages();
    });

    _messageController.clear();

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
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
                  borderRadius: BorderRadius.circular(10),
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
                icon: Icons.person_outline,
                title: 'Voir le profil',
                onTap: () {
                  Navigator.pop(context);
                  _showMessage(
                    'Le profil détaillé sera bientôt disponible.',
                  );
                },
              ),
              _OptionTile(
                icon: Icons.notifications_off_outlined,
                title: 'Mettre la conversation en sourdine',
                onTap: () {
                  Navigator.pop(context);
                  _showMessage(
                    'Les notifications pourront être désactivées ici.',
                  );
                },
              ),
              _OptionTile(
                icon: Icons.delete_outline,
                title: 'Supprimer la conversation',
                onTap: () {
                  Navigator.pop(context);
                  _confirmDeleteConversation();
                },
              ),
              _OptionTile(
                icon: Icons.block_outlined,
                title: 'Bloquer cette personne',
                color: const Color(0xFFC62861),
                onTap: () {
                  Navigator.pop(context);
                  _confirmBlock();
                },
              ),
              _OptionTile(
                icon: Icons.flag_outlined,
                title: 'Signaler',
                color: const Color(0xFFC62861),
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
            'Les messages avec ${widget.profile.name} seront supprimés de cet appareil.',
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

                await MessageService.deleteConversation(
                  widget.profile,
                );

                if (!mounted) {
                  return;
                }

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Conversation supprimée.',
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFED1767),
                foregroundColor: Colors.white,
              ),
              child: const Text('Supprimer'),
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
            '${widget.profile.name} ne pourra plus apparaître dans tes Matchs, Messages ou Découvrir.',
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

                await MessageService.deleteConversation(
                  widget.profile,
                );

                if (!mounted) {
                  return;
                }

                setState(() {
                  _isBlocked = true;
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${widget.profile.name} a été bloqué(e).',
                    ),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD32F2F),
                foregroundColor: Colors.white,
              ),
              child: const Text('Bloquer'),
            ),
          ],
        );
      },
    );
  }

  void _showReportDialog() {
    final TextEditingController reasonController =
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Indique pourquoi tu souhaites signaler cette personne.',
                style: TextStyle(
                  color: Color(0xFF666666),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: reasonController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Motif du signalement',
                  filled: true,
                  fillColor: const Color(0xFFF7F7F7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          actions: [
            TextButton(
              onPressed: () {
                reasonController.dispose();
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                final reason =
                    reasonController.text.trim();

                if (reason.isEmpty) {
                  return;
                }

                await ReportService.reportProfile(
                  profileId: widget.profile.id,
                  reason: reason,
                );

                reasonController.dispose();

                if (!mounted) {
                  return;
                }

                Navigator.pop(context);

                _showMessage(
                  'Merci. Ton signalement a été enregistré.',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC62861),
                foregroundColor: Colors.white,
              ),
              child: const Text('Signaler'),
            ),
          ],
        );
      },
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  bool _isMine(String message, int index) {
    if (_myMessages.contains(message)) {
      return true;
    }

    // Les messages de démonstration existants sont reçus.
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF333333),
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFFD2E2),
                        Color(0xFFFFEEF4),
                      ],
                    ),
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
                if (!_isBlocked)
                  Positioned(
                    right: 0,
                    bottom: 1,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFF45B96B),
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
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      if (widget.profile.verified) ...[
                        const SizedBox(width: 5),
                        const Icon(
                          Icons.verified,
                          size: 16,
                          color: Color(0xFF3298DB),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _isBlocked ? 'Bloqué(e)' : 'En ligne',
                    style: TextStyle(
                      fontSize: 12,
                      color: _isBlocked
                          ? const Color(0xFFD32F2F)
                          : const Color(0xFF45B96B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Options',
            icon: const Icon(
              Icons.more_vert,
              color: Color(0xFF555555),
            ),
            onPressed: _showOptions,
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: _isBlocked
          ? _buildBlockedState()
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      20,
                      16,
                      15,
                    ),
                    itemCount: _messages.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildConversationIntro();
                      }

                      final message =
                          _messages[index - 1];

                      return _MessageBubble(
                        text: message,
                        isMine: _isMine(
                          message,
                          index - 1,
                        ),
                        profile: widget.profile,
                      );
                    },
                  ),
                ),
                _buildMessageInput(),
              ],
            ),
    );
  }

  Widget _buildBlockedState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: Color(0xFFFFE5EF),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.block,
                  size: 55,
                  color: Color(0xFFD32F2F),
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Personne bloquée',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${widget.profile.name} a été bloqué(e).',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF777777),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversationIntro() {
    return Column(
      children: [
        const SizedBox(height: 5),
        Container(
          width: 76,
          height: 76,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFD2E2),
                Color(0xFFFFEEF4),
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              widget.profile.emoji,
              style: const TextStyle(
                fontSize: 42,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '${widget.profile.name}, ${widget.profile.age}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 15,
              color: Color(0xFFC52A70),
            ),
            const SizedBox(width: 4),
            Text(
              widget.profile.city,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF888888),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFFEAF2),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Text(
            '💕 Vous avez un Match',
            style: TextStyle(
              color: Color(0xFFC52A70),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _buildMessageInput() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          12,
          10,
          12,
          10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE5EF),
                borderRadius: BorderRadius.circular(15),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.add,
                  color: Color(0xFFC52A70),
                ),
                onPressed: () {
                  _showMessage(
                    'Les pièces jointes seront bientôt disponibles.',
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _messageController,
                enabled: !_isBlocked,
                textInputAction: TextInputAction.send,
                minLines: 1,
                maxLines: 4,
                onSubmitted: (_) {
                  _sendMessage();
                },
                decoration: InputDecoration(
                  hintText: 'Écris un message...',
                  hintStyle: const TextStyle(
                    color: Color(0xFFAAAAAA),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF7F7F7),
                  contentPadding:
                      const EdgeInsets.symmetric(
                    horizontal: 17,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: _isBlocked
                  ? const Color(0xFFCCCCCC)
                  : const Color(0xFFED1767),
              borderRadius: BorderRadius.circular(18),
              child: InkWell(
                onTap: _isBlocked ? null : _sendMessage,
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  width: 49,
                  height: 49,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String text;
  final bool isMine;
  final DatingProfile profile;

  const _MessageBubble({
    required this.text,
    required this.isMine,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    if (isMine) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          constraints: BoxConstraints(
            maxWidth:
                MediaQuery.of(context).size.width * 0.78,
          ),
          margin: const EdgeInsets.only(
            bottom: 12,
            left: 45,
          ),
          padding: const EdgeInsets.fromLTRB(
            16,
            11,
            12,
            8,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFED1767),
                Color(0xFFD80A58),
              ],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(22),
              topRight: Radius.circular(22),
              bottomLeft: Radius.circular(22),
              bottomRight: Radius.circular(6),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              height: 1.35,
            ),
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.end,
        children: [
          Container(
            width: 34,
            height: 34,
            margin: const EdgeInsets.only(
              right: 8,
              bottom: 12,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFFFFE5EF),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                profile.emoji,
                style: const TextStyle(
                  fontSize: 19,
                ),
              ),
            ),
          ),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth:
                    MediaQuery.of(context).size.width *
                        0.72,
              ),
              margin: const EdgeInsets.only(
                bottom: 12,
              ),
              padding: const EdgeInsets.fromLTRB(
                15,
                11,
                12,
                11,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(22),
                  topRight: Radius.circular(22),
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(22),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                text,
                style: const TextStyle(
                  color: Color(0xFF444444),
                  fontSize: 15,
                  height: 1.35,
                ),
              ),
            ),
          ),
        ],
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
    this.color = const Color(0xFF555555),
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 2,
      ),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFFFEAF2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          icon,
          color: color,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }
}
