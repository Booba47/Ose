import '../models/dating_profile.dart';

class LikeService {
  static final Set<String> _likedProfileIds = {};

  static final Set<String> _passedProfileIds = {};

  static void likeProfile(DatingProfile profile) {
    _likedProfileIds.add(profile.id);
    _passedProfileIds.remove(profile.id);
  }

  static void passProfile(DatingProfile profile) {
    _passedProfileIds.add(profile.id);
    _likedProfileIds.remove(profile.id);
  }

  static bool hasLiked(DatingProfile profile) {
    return _likedProfileIds.contains(profile.id);
  }

  static bool hasPassed(DatingProfile profile) {
    return _passedProfileIds.contains(profile.id);
  }

  static List<String> get likedProfileIds {
    return List.unmodifiable(
      _likedProfileIds,
    );
  }

  static List<String> get passedProfileIds {
    return List.unmodifiable(
      _passedProfileIds,
    );
  }

  static void clear() {
    _likedProfileIds.clear();
    _passedProfileIds.clear();
  }
}
