import '../models/dating_profile.dart';
import '../models/chat_message.dart';
import 'message_service.dart';

class UnreadMessageService {
  static final Map<String, int> _unreadCounts = {};


  /// Retourne le nombre de messages non lus pour un profil
  static int getUnreadCount(
    DatingProfile profile,
  ) {
    return _unreadCounts[profile.id] ?? 0;
  }



  /// Vérifie si un profil possède des messages non lus
  static bool hasUnreadMessages(
    DatingProfile profile,
  ) {
    return getUnreadCount(profile) > 0;
  }



  /// Nombre total de messages non lus
  static int get totalUnreadCount {

    return _unreadCounts.values.fold(
      0,
      (sum, count) => sum + count,
    );
  }



  /// Vérifie s'il existe au moins un message non lu
  static bool get hasAnyUnreadMessages {

    return totalUnreadCount > 0;
  }



  /// Ajoute un nouveau message non lu
  static Future<void> markAsUnread(
    DatingProfile profile,
  ) async {

    _unreadCounts[profile.id] =
        getUnreadCount(profile) + 1;
  }




  /// Supprime le compteur de messages lus
  static Future<void> markAsRead(
    DatingProfile profile,
  ) async {

    _unreadCounts.remove(
      profile.id,
    );
  }




  /// Nouvelle méthode :
  /// synchronise MessageService + compteur
  static Future<void> markConversationAsRead(
    DatingProfile profile,
  ) async {

    await MessageService.markAsRead(
      profile,
    );

    await markAsRead(
      profile,
    );
  }




  /// Synchronisation avec les messages existants
  static Future<void> sync(
    DatingProfile profile,
  ) async {

    final messages =
        MessageService.getMessages(
      profile,
    );


    final unreadMessages =
        messages.where(
      (ChatMessage message) {

        return !message.isMine &&
            !message.isRead;

      },
    ).length;



    if (unreadMessages == 0) {

      _unreadCounts.remove(
        profile.id,
      );

    } else {

      _unreadCounts[profile.id] =
          unreadMessages;
    }
  }




  /// Retourne les IDs des profils avec messages non lus
  static List<String> get unreadProfileIds {

    return List.unmodifiable(
      _unreadCounts.keys,
    );
  }




  /// Efface tous les compteurs
  static Future<void> clear() async {

    _unreadCounts.clear();

  }
}
