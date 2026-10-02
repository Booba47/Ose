class ChatMessage {
  final String id;
  final String profileId;
  final String text;
  final bool isMine;
  final DateTime sentAt;
  final bool isRead;

  const ChatMessage({
    required this.id,
    required this.profileId,
    required this.text,
    required this.isMine,
    required this.sentAt,
    this.isRead = false,
  });

  ChatMessage copyWith({
    String? id,
    String? profileId,
    String? text,
    bool? isMine,
    DateTime? sentAt,
    bool? isRead,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      text: text ?? this.text,
      isMine: isMine ?? this.isMine,
      sentAt: sentAt ?? this.sentAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
