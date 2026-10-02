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

  static List<ChatMessage> getMessages(
    DatingProfile profile,
  ) {
    return List.unmodifiable(
      _messages[profile.id] ?? [],
    );
  }

  static Future<void> sendMessage({
    required DatingProfile profile,
    required String message,
  }) async {
    final text = message.trim();

    if (text.isEmpty) {
      return;
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
  }

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

  static bool hasConversation(
    DatingProfile profile,
  ) {
    final messages = _messages[profile.id];
    return messages != null && messages.isNotEmpty;
  }

  static ChatMessage? getLastMessage(
    DatingProfile profile,
  ) {
    final messages = _messages[profile.id];

    if (messages == null || messages.isEmpty) {
      return null;
    }

    return messages.last;
  }

  static Future<void> deleteConversation(
    DatingProfile profile,
  ) async {
    _messages.remove(profile.id);
  }

  static Future<void> clear() async {
    _messages.clear();
  }

  static int get conversationCount =>
      _messages.length;
}
