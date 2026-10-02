import '../models/dating_profile.dart';
import 'dating_profile_service.dart';

class SearchService {
  /// Recherche des profils par nom, ville ou centre d'intérêt.
  static List<DatingProfile> search({
    String query = '',
    String? city,
  }) {
    final profiles =
        DatingProfileService.getProfiles();

    final cleanQuery = query.trim().toLowerCase();
    final cleanCity = city?.trim().toLowerCase();

    return profiles.where((profile) {
      final matchesQuery =
          cleanQuery.isEmpty ||
          profile.name.toLowerCase().contains(cleanQuery) ||
          profile.city.toLowerCase().contains(cleanQuery) ||
          profile.interests.any(
            (interest) => interest
                .toLowerCase()
                .contains(cleanQuery),
          );

      final matchesCity =
          cleanCity == null ||
          cleanCity.isEmpty ||
          profile.city.toLowerCase() == cleanCity;

      return matchesQuery && matchesCity;
    }).toList();
  }

  /// Recherche uniquement les profils vérifiés.
  static List<DatingProfile> searchVerified({
    String query = '',
  }) {
    return search(query: query)
        .where((profile) => profile.verified)
        .toList();
  }

  /// Recherche les profils dans une tranche d'âge.
  static List<DatingProfile> searchByAge({
    required int minimumAge,
    required int maximumAge,
  }) {
    return DatingProfileService.getProfiles()
        .where(
          (profile) =>
              profile.age >= minimumAge &&
              profile.age <= maximumAge,
        )
        .toList();
  }

  /// Retourne tous les profils disponibles.
  static List<DatingProfile> getAllProfiles() {
    return DatingProfileService.getProfiles();
  }
}
