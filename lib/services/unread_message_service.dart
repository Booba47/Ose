import '../models/chat_message.dart';
import '../models/dating_profile.dart';
import 'message_service.dart';

class UnreadMessageService {
  static final Map<String, int> _unreadCounts = {};

  /// Nombre de messages non lus pour un profil.
  static int getUnreadCount(
    DatingProfile profile,
  ) {
    return _unreadCounts[profile.id] ?? 0;
  }

  /// Vérifie si une conversation contient des messages non lus.
  static bool hasUnreadMessages(
    DatingProfile profile,
  ) {
    return getUnreadCount(profile) > 0;
  }

  /// Nombre total de messages non lus.
  static int get totalUnreadCount {
    return _unreadCounts.values.fold(
      0,
      (sum, count) => sum + count,
    );
  }

  /// Vérifie s'il existe au moins un message non lu.
  static bool get hasAnyUnreadMessages {
    return totalUnreadCount > 0;
  }

  /// Ajoute un message non lu.
  static Future<void> markAsUnread(
    DatingProfile profile,
  ) async {
    final profileId = profile.id.trim();

    if (profileId.isEmpty) {
      return;
    }

    _unreadCounts[profileId] =
        getUnreadCount(profile) + 1;
  }

  /// Marque une conversation comme lue.
  static Future<void> markAsRead(
    DatingProfile profile,
  ) async {
    _unreadCounts.remove(profile.id);
  }

  /// Marque les messages du chat comme lus.
  static Future<void> markConversationAsRead(
    DatingProfile profile,
  ) async {
    await MessageService.markAsRead(profile);
    await markAsRead(profile);
  }

  /// Synchronise le compteur avec les messages réels.
  static Future<void> sync(
    DatingProfile profile,
  ) async {
    final messages =
        MessageService.getMessages(profile);

    final unreadMessages = messages.where(
      (ChatMessage message) {
        return !message.isMine &&
            !message.isRead;
      },
    ).length;

    if (unreadMessages == 0) {
      _unreadCounts.remove(profile.id);
    } else {
      _unreadCounts[profile.id] =
          unreadMessages;
    }
  }

  /// Identifiants des conversations contenant
  /// des messages non lus.
  static List<String> get unreadProfileIds {
    return List.unmodifiable(
      _unreadCounts.keys,
    );
  }

  /// Réinitialise tous les compteurs.
  static Future<void> clear() async {
    _unreadCounts.clear();
  }
} 
