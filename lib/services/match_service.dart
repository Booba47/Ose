import '../models/dating_profile.dart';
import 'like_service.dart';

class MatchService {
  static final Set<String> _matchedProfileIds = {};

  static bool checkForMatch(DatingProfile profile) {
    if (!LikeService.hasLiked(profile)) {
      return false;
    }

    return _matchedProfileIds.contains(profile.id);
  }

  static void createMatch(DatingProfile profile) {
    _matchedProfileIds.add(profile.id);
  }

  static bool isMatched(DatingProfile profile) {
    return _matchedProfileIds.contains(profile.id);
  }

  static List<String> get matchedProfileIds {
    return List.unmodifiable(
      _matchedProfileIds,
    );
  }

  static void removeMatch(DatingProfile profile) {
    _matchedProfileIds.remove(profile.id);
  }

  static void clear() {
    _matchedProfileIds.clear();
  }
}
