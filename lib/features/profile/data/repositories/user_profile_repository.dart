import '../models/user_profile.dart';
import '../services/user_profile_service.dart';

class UserProfileRepository {
  final UserProfileService _service = UserProfileService();

  Future<UserProfile?> getCurrentUserProfile() {
    return _service.getCurrentUserProfile();
  }

  Future<void> updateUserProfile(UserProfile profile) {
    return _service.updateUserProfile(profile);
  }

  Future<void> addToFavorites(String tourId) {
    return _service.addToFavorites(tourId);
  }

  Future<void> removeFromFavorites(String tourId) {
    return _service.removeFromFavorites(tourId);
  }

  Future<bool> isFavorite(String tourId) {
    return _service.isFavorite(tourId);
  }

  Future<List<String>> getFavoriteTours() {
    return _service.getFavoriteTours();
  }
}
