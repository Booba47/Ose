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


  /// Envoyer un message
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

        profileId: profile.id,

        text: text,

        isMine: true,

        sentAt: DateTime.now(),

        isRead: false,
      ),
    );


    await NotificationService.addNotification(
      title: 'Message envoyé',
      body: 'Message envoyé à ${profile.name}',
    );
  }



  /// Recevoir un message
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

        profileId: profile.id,

        text: text,

        isMine: false,

        sentAt: DateTime.now(),

        isRead: false,
      ),
    );



    await NotificationService.addNotification(
      title: 'Nouveau message',
      body: '${profile.name} t’a envoyé un message',
    );
  }




  /// Marquer une conversation comme lue
  static Future<void> markAsRead(
    DatingProfile profile,
  ) async {

    final key = _conversationKey(profile);

    final messages = _conversations[key];


    if (messages == null) {
      return;
    }


    _conversations[key] =
        messages.map(
      (message) {

        if (!message.isMine &&
            !message.isRead) {

          return message.copyWith(
            isRead: true,
          );
        }


        return message;
      },
    ).toList();
  }




  /// Nombre de messages non lus
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




  /// Dernier message
  static ChatMessage? lastMessage(
    DatingProfile profile,
  ) {

    final messages =
        _conversations[_conversationKey(profile)];


    if (messages == null ||
        messages.isEmpty) {

      return null;
    }


    return messages.last;
  }



  /// Compatibilité avec MessagesScreen
  static ChatMessage? getLastMessage(
    DatingProfile profile,
  ) {

    return lastMessage(profile);
  }




  /// Supprimer une conversation
  static Future<void> deleteConversation(
    DatingProfile profile,
  ) async {

    _conversations.remove(
      _conversationKey(profile),
    );
  }




  /// Vérifier si une conversation existe
  static bool hasConversation(
    DatingProfile profile,
  ) {

    final messages =
        _conversations[_conversationKey(profile)];


    return messages != null &&
        messages.isNotEmpty;
  }




  /// Liste des conversations
  static List<String> get conversationIds {

    return List.unmodifiable(
      _conversations.keys,
    );
  }




  /// Tout supprimer
  static Future<void> clear() async {

    _conversations.clear();

  }
}
