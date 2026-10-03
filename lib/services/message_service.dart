import '../models/chat_message.dart';
import '../models/dating_profile.dart';
import 'notification_service.dart';

class MessageService {
  static final Map<String, List<ChatMessage>> _conversations = {};

  static String _conversationKey(DatingProfile profile) {
    return profile.id;
  }

  /// Récupère les messages d'une conversation
  static List<ChatMessage> getMessages(
    DatingProfile profile,
  ) {
    final key = _conversationKey(profile);

    return List.unmodifiable(
      _conversations[key] ?? [],
    );
  }

  /// Envoie un message
  static Future<void> sendMessage({
    required DatingProfile profile,
    required String message,
  }) async {
    final text = message.trim();

    if (text.isEmpty) {
      return;
    }

    final key = _conversationKey(profile);

    _conversations.putIfAbsent(
      key,
      () => [],
    );

    _conversations[key]!.add(
      ChatMessage(
        id: DateTime.now()
            .millisecondsSinceEpoch
            .toString(),
        text: text,
        sentAt: DateTime.now(),
        isMine: true,
        isRead: false,
      ),
    );

    await NotificationService.addNotification(
      'Message envoyé à ${profile.name}',
    );
  }

  /// Ajoute un message reçu (simulation serveur)
  static Future<void> receiveMessage({
    required DatingProfile profile,
    required String message,
  }) async {
    final text = message.trim();

    if (text.isEmpty) {
      return;
    }

    final key = _conversationKey(profile);

    _conversations.putIfAbsent(
      key,
      () => [],
    );

    _conversations[key]!.add(
      ChatMessage(
        id: DateTime.now()
            .millisecondsSinceEpoch
            .toString(),
        text: text,
        sentAt: DateTime.now(),
        isMine: false,
        isRead: false,
      ),
    );

    await NotificationService.addNotification(
      '${profile.name} t’a envoyé un message',
    );
  }

  /// Marque les messages comme lus
  static Future<void> markAsRead(
    DatingProfile profile,
  ) async {
    final key = _conversationKey(profile);

    final messages = _conversations[key];

    if (messages == null) {
      return;
    }

    for (final message in messages) {
      if (!message.isMine) {
        message.isRead = true;
      }
    }
  }

  /// Nombre de messages non lus
  static int unreadCount(
    DatingProfile profile,
  ) {
    final messages =
        _conversations[_conversationKey(profile)] ?? [];

    return messages
        .where(
          (message) =>
              !message.isMine &&
              !message.isRead,
        )
        .length;
  }

  /// Supprime une conversation
  static Future<void> deleteConversation(
    DatingProfile profile,
  ) async {
    _conversations.remove(
      _conversationKey(profile),
    );
  }

  /// Supprime tous les messages
  static Future<void> clear() async {
    _conversations.clear();
  }

  /// Vérifie si une conversation existe
  static bool hasConversation(
    DatingProfile profile,
  ) {
    return _conversations.containsKey(
      _conversationKey(profile),
    );
  }

  /// Retourne toutes les conversations
  static List<String> get conversationIds {
    return List.unmodifiable(
      _conversations.keys,
    );
  }
}
