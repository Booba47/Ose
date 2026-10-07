import '../models/dating_profile.dart';
import 'dating_profile_service.dart';

class SearchService {
  /// Recherche générale par nom, ville ou intérêt.
  static List<DatingProfile> search({
    String query = '',
    String? city,
  }) {
    final profiles = DatingProfileService.getProfiles();

    final cleanQuery = query.trim().toLowerCase();
    final cleanCity = city?.trim().toLowerCase();

    return profiles.where((profile) {
      final matchesQuery =
          cleanQuery.isEmpty ||
          profile.name.toLowerCase().contains(cleanQuery) ||
          profile.city.toLowerCase().contains(cleanQuery) ||
          profile.interests.any(
            (interest) =>
                interest.toLowerCase().contains(cleanQuery),
          );

      final matchesCity =
          cleanCity == null ||
          cleanCity.isEmpty ||
          profile.city.toLowerCase() == cleanCity;

      return matchesQuery && matchesCity;
    }).toList();
  }

  /// Recherche uniquement parmi les profils vérifiés.
  static List<DatingProfile> searchVerified({
    String query = '',
  }) {
    return search(query: query)
        .where((profile) => profile.verified)
        .toList();
  }

  /// Recherche par tranche d'âge.
  static List<DatingProfile> searchByAge({
    required int minimumAge,
    required int maximumAge,
  }) {
    if (minimumAge > maximumAge) {
      return [];
    }

    return DatingProfileService.getProfiles()
        .where(
          (profile) =>
              profile.age >= minimumAge &&
              profile.age <= maximumAge,
        )
        .toList();
  }

  /// Récupère tous les profils.
  static List<DatingProfile> getAllProfiles() {
    return DatingProfileService.getProfiles();
  }

  /// Recherche par ville.
  static List<DatingProfile> searchByCity(
    String city,
  ) {
    return search(city: city);
  }

  /// Recherche par intérêt.
  static List<DatingProfile> searchByInterest(
    String interest,
  ) {
    final cleanInterest = interest.trim().toLowerCase();

    if (cleanInterest.isEmpty) {
      return [];
    }

    return DatingProfileService.getProfiles()
        .where(
          (profile) => profile.interests.any(
            (item) =>
                item.toLowerCase().contains(cleanInterest),
          ),
        )
        .toList();
  }
} 
