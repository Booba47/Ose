import '../models/dating_profile.dart';

class MessageService {
  static final Map<String, List<String>> _messages = {
    'profile_1': [
      'Salut 😊',
      'Content(e) de faire ta connaissance !',
    ],
    'profile_3': [
      'Bonjour 😊',
      'Ravie de discuter avec toi !',
    ],
  };

  /// Retourne les messages d'une conversation.
  static List<String> getMessages(DatingProfile profile) {
    return List.unmodifiable(
      _messages[profile.id] ?? [],
    );
  }

  /// Ajoute un message à une conversation.
  static Future<void> sendMessage({
    required DatingProfile profile,
    required String message,
  }) async {
    final text = message.trim();

    if (text.isEmpty) {
      return;
    }

    _messages.putIfAbsent(
      profile.id,
      () => [],
    );

    _messages[profile.id]!.add(text);
  }

  /// Indique si une conversation existe.
  static bool hasConversation(DatingProfile profile) {
    return _messages.containsKey(profile.id);
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
}
