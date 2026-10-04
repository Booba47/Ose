import '../models/chat_message.dart';
import '../models/dating_profile.dart';
import 'notification_service.dart';

class MessageService {
  static final Map<String, List<ChatMessage>> _conversations = {};

  /// Identifiant unique d'une conversation.
  static String _conversationKey(
    DatingProfile profile,
  ) {
    return profile.id.trim();
  }

  /// Récupère tous les messages d'une conversation.
  static List<ChatMessage> getMessages(
    DatingProfile profile,
  ) {
    final key = _conversationKey(profile);

    return List.unmodifiable(
      _conversations[key] ?? [],
    );
  }

  /// Envoie un message.
  static Future<void> sendMessage({
    required DatingProfile profile,
    required String message,
  }) async {
    final text = message.trim();

    if (text.isEmpty) {
      return;
    }

    final key = _conversationKey(profile);

    if (key.isEmpty) {
      return;
    }

    _conversations.putIfAbsent(
      key,
      () => [],
    );

    final now = DateTime.now();

    _conversations[key]!.add(
      ChatMessage(
        id: '${now.millisecondsSinceEpoch}_mine',
        profileId: profile.id,
        text: text,
        isMine: true,
        sentAt: now,
        isRead: true,
      ),
    );

    await NotificationService.addNotification(
      message: 'Message envoyé à ${profile.name}',
    );
  }

  /// Simule la réception d'un message.
  ///
  /// Cette méthode sera remplacée plus tard par
  /// le système temps réel du backend.
  static Future<void> receiveMessage({
    required DatingProfile profile,
    required String message,
  }) async {
    final text = message.trim();

    if (text.isEmpty) {
      return;
    }

    final key = _conversationKey(profile);

    if (key.isEmpty) {
      return;
    }

    _conversations.putIfAbsent(
      key,
      () => [],
    );

    final now = DateTime.now();

    _conversations[key]!.add(
      ChatMessage(
        id: '${now.millisecondsSinceEpoch}_received',
        profileId: profile.id,
        text: text,
        isMine: false,
        sentAt: now,
        isRead: false,
      ),
    );

    await NotificationService.addNotification(
      message: '${profile.name} t’a envoyé un message',
    );
  }

  /// Marque les messages reçus comme lus.
  static Future<void> markAsRead(
    DatingProfile profile,
  ) async {
    final key = _conversationKey(profile);
    final messages = _conversations[key];

    if (messages == null) {
      return;
    }

    _conversations[key] = messages.map(
      (message) {
        if (!message.isMine && !message.isRead) {
          return message.copyWith(
            isRead: true,
          );
        }

        return message;
      },
    ).toList();
  }

  /// Nombre de messages non lus.
  static int unreadCount(
    DatingProfile profile,
  ) {
    final messages =
        _conversations[_conversationKey(profile)] ?? [];

    return messages.where(
      (message) {
        return !message.isMine &&
            !message.isRead;
      },
    ).length;
  }

  /// Dernier message de la conversation.
  static ChatMessage? lastMessage(
    DatingProfile profile,
  ) {
    final messages =
        _conversations[_conversationKey(profile)];

    if (messages == null || messages.isEmpty) {
      return null;
    }

    return messages.last;
  }

  /// Alias conservé pour compatibilité.
  static ChatMessage? getLastMessage(
    DatingProfile profile,
  ) {
    return lastMessage(profile);
  }

  /// Supprime une conversation.
  static Future<void> deleteConversation(
    DatingProfile profile,
  ) async {
    _conversations.remove(
      _conversationKey(profile),
    );
  }

  /// Vérifie si une conversation existe.
  static bool hasConversation(
    DatingProfile profile,
  ) {
    final messages =
        _conversations[_conversationKey(profile)];

    return messages != null &&
        messages.isNotEmpty;
  }

  /// Identifiants des conversations existantes.
  static List<String> get conversationIds {
    return List.unmodifiable(
      _conversations.keys,
    );
  }

  /// Supprime toutes les conversations locales.
  static Future<void> clear() async {
    _conversations.clear();
  }
} 
