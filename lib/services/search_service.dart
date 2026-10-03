import '../models/dating_profile.dart';
import 'block_service.dart';
import 'dating_profile_service.dart';

class SearchService {
  /// Recherche générale.
  ///
  /// La recherche porte sur :
  /// - prénom
  /// - ville
  /// - centres d'intérêt
  static List<DatingProfile> search({
    String query = '',
    String? city,
    int? minimumAge,
    int? maximumAge,
    bool verifiedOnly = false,
    bool excludeBlocked = true,
  }) {
    final profiles = DatingProfileService.getProfiles();

    final cleanQuery = query.trim().toLowerCase();
    final cleanCity = city?.trim().toLowerCase();

    return profiles.where((profile) {
      // Recherche texte.
      final matchesQuery =
          cleanQuery.isEmpty ||
          profile.name
              .toLowerCase()
              .contains(cleanQuery) ||
          profile.city
              .toLowerCase()
              .contains(cleanQuery) ||
          profile.interests.any(
            (interest) => interest
                .toLowerCase()
                .contains(cleanQuery),
          );

      // Filtre ville.
      final matchesCity =
          cleanCity == null ||
          cleanCity.isEmpty ||
          profile.city.toLowerCase() == cleanCity;

      // Filtre âge minimum.
      final matchesMinimumAge =
          minimumAge == null ||
          profile.age >= minimumAge;

      // Filtre âge maximum.
      final matchesMaximumAge =
          maximumAge == null ||
          profile.age <= maximumAge;

      // Filtre profils vérifiés.
      final matchesVerified =
          !verifiedOnly || profile.verified;

      // Exclusion des profils bloqués.
      final matchesBlocked =
          !excludeBlocked ||
          !BlockService.isBlocked(profile);

      return matchesQuery &&
          matchesCity &&
          matchesMinimumAge &&
          matchesMaximumAge &&
          matchesVerified &&
          matchesBlocked;
    }).toList();
  }

  /// Recherche uniquement parmi les profils vérifiés.
  static List<DatingProfile> searchVerified({
    String query = '',
    String? city,
    int? minimumAge,
    int? maximumAge,
  }) {
    return search(
      query: query,
      city: city,
      minimumAge: minimumAge,
      maximumAge: maximumAge,
      verifiedOnly: true,
    );
  }

  /// Recherche par tranche d'âge.
  static List<DatingProfile> searchByAge({
    required int minimumAge,
    required int maximumAge,
  }) {
    if (minimumAge > maximumAge) {
      return const [];
    }

    return search(
      minimumAge: minimumAge,
      maximumAge: maximumAge,
    );
  }

  /// Recherche par ville.
  static List<DatingProfile> searchByCity(
    String city,
  ) {
    final cleanCity = city.trim();

    if (cleanCity.isEmpty) {
      return const [];
    }

    return search(
      city: cleanCity,
    );
  }

  /// Recherche par centre d'intérêt.
  static List<DatingProfile> searchByInterest(
    String interest,
  ) {
    final cleanInterest = interest.trim().toLowerCase();

    if (cleanInterest.isEmpty) {
      return const [];
    }

    return DatingProfileService.getProfiles()
        .where((profile) {
      if (BlockService.isBlocked(profile)) {
        return false;
      }

      return profile.interests.any(
        (profileInterest) =>
            profileInterest
                .toLowerCase()
                .contains(cleanInterest),
      );
    }).toList();
  }

  /// Retourne tous les profils non bloqués.
  static List<DatingProfile> getAllProfiles({
    bool excludeBlocked = true,
  }) {
    return search(
      excludeBlocked: excludeBlocked,
    );
  }

  /// Retourne la liste des villes disponibles.
  static List<String> getAvailableCities() {
    final cities = DatingProfileService.getProfiles()
        .map((profile) => profile.city.trim())
        .where((city) => city.isNotEmpty)
        .toSet()
        .toList();

    cities.sort();

    return List.unmodifiable(cities);
  }

  /// Retourne les profils correspondant à plusieurs critères.
  static List<DatingProfile> advancedSearch({
    String query = '',
    String? city,
    int? minimumAge,
    int? maximumAge,
    bool verifiedOnly = false,
  }) {
    return search(
      query: query,
      city: city,
      minimumAge: minimumAge,
      maximumAge: maximumAge,
      verifiedOnly: verifiedOnly,
      excludeBlocked: true,
    );
  }
}
