import 'in_app_review_platform_interface.dart';

class InAppReview {
  InAppReview._();

  /// The singleton instance of the InAppReview class.
  static final InAppReview instance = InAppReview._();

  /// Checks if in-app review is available on the current platform.
  ///
  /// Returns a Future<bool> indicating whether in-app review is available.
  Future<bool> isAvailable() => InAppReviewPlatform.instance.isAvailable();

  /// Requests an in-app review.
  ///
  /// Returns a Future<void> indicating the success or failure of the request.
  Future<void> requestReview() => InAppReviewPlatform.instance.requestReview();

  /// Opens the store for leaving a review.
  ///
  /// Parameters:
  /// - [appStoreId]: The App Store ID for the app (iOS only).
  ///
  /// Returns a Future<void> indicating the success or failure of opening the store.
  Future<void> openStore({
    String? appStoreId,
  }) =>
      InAppReviewPlatform.instance.openStore(
        appStoreId: appStoreId,
      );
}
