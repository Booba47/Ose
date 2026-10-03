import '../models/chat_message.dart';
import '../models/dating_profile.dart';

class MessageService {
  static final Map<String, List<ChatMessage>> _messages = {
    'profile_1': [
      ChatMessage(
        id: 'message_1',
        profileId: 'profile_1',
        text: 'Salut 😊',
        isMine: false,
        sentAt: DateTime(2026, 1, 1, 18, 30),
        isRead: true,
      ),
      ChatMessage(
        id: 'message_2',
        profileId: 'profile_1',
        text: 'Content(e) de faire ta connaissance !',
        isMine: false,
        sentAt: DateTime(2026, 1, 1, 18, 31),
        isRead: true,
      ),
    ],
    'profile_3': [
      ChatMessage(
        id: 'message_3',
        profileId: 'profile_3',
        text: 'Bonjour 😊',
        isMine: false,
        sentAt: DateTime(2026, 1, 2, 19, 15),
        isRead: true,
      ),
      ChatMessage(
        id: 'message_4',
        profileId: 'profile_3',
        text: 'Ravie de discuter avec toi !',
        isMine: false,
        sentAt: DateTime(2026, 1, 2, 19, 16),
        isRead: true,
      ),
    ],
  };

  /// Retourne tous les messages d'une conversation.
  static List<ChatMessage> getMessages(
    DatingProfile profile,
  ) {
    final messages = _messages[profile.id];

    if (messages == null) {
      return const [];
    }

    return List.unmodifiable(messages);
  }

  /// Envoie un message.
  static Future<bool> sendMessage({
    required DatingProfile profile,
    required String message,
  }) async {
    final text = message.trim();

    if (text.isEmpty) {
      return false;
    }

    final messages =
        _messages.putIfAbsent(profile.id, () => []);

    messages.add(
      ChatMessage(
        id: 'message_${DateTime.now().microsecondsSinceEpoch}',
        profileId: profile.id,
        text: text,
        isMine: true,
        sentAt: DateTime.now(),
        isRead: false,
      ),
    );

    return true;
  }

  /// Marque les messages reçus comme lus.
  static Future<void> markAsRead(
    DatingProfile profile,
  ) async {
    final messages = _messages[profile.id];

    if (messages == null) {
      return;
    }

    for (var i = 0; i < messages.length; i++) {
      final message = messages[i];

      if (!message.isMine && !message.isRead) {
        messages[i] = message.copyWith(
          isRead: true,
        );
      }
    }
  }

  /// Vérifie si une conversation existe.
  static bool hasConversation(
    DatingProfile profile,
  ) {
    final messages = _messages[profile.id];

    return messages != null &&
        messages.isNotEmpty;
  }

  /// Retourne le dernier message.
  static ChatMessage? getLastMessage(
    DatingProfile profile,
  ) {
    final messages = _messages[profile.id];

    if (messages == null || messages.isEmpty) {
      return null;
    }

    return messages.last;
  }

  /// Nombre de messages dans une conversation.
  static int getMessageCount(
    DatingProfile profile,
  ) {
    return _messages[profile.id]?.length ?? 0;
  }

  /// Nombre de messages non lus dans une conversation.
  static int getUnreadCount(
    DatingProfile profile,
  ) {
    final messages = _messages[profile.id];

    if (messages == null) {
      return 0;
    }

    return messages.where(
      (message) =>
          !message.isMine &&
          !message.isRead,
    ).length;
  }

  /// Vérifie s'il existe des messages non lus.
  static bool hasUnreadMessages(
    DatingProfile profile,
  ) {
    return getUnreadCount(profile) > 0;
  }

  /// Supprime une conversation.
  static Future<void> deleteConversation(
    DatingProfile profile,
  ) async {
    _messages.remove(profile.id);
  }

  /// Supprime toutes les conversations.
  static Future<void> clear() async {
    _messages.clear();
  }

  /// Nombre de conversations.
  static int get conversationCount {
    return _messages.length;
  }

  /// Nombre total de messages.
  static int get totalMessageCount {
    return _messages.values.fold(
      0,
      (total, messages) => total + messages.length,
    );
  }
}
