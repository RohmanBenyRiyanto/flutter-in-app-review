import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'in_app_review_method_channel.dart';

abstract class InAppReviewPlatform extends PlatformInterface {
  InAppReviewPlatform() : super(token: _token);

  static InAppReviewPlatform _instance = MethodChannelInAppReview();

  static final Object _token = Object();

  /// The singleton instance of the InAppReviewPlatform.
  ///
  /// This should be used to access the platform-specific implementation of
  /// InAppReviewPlatform.
  static InAppReviewPlatform get instance => _instance;

  /// Set the platform-specific instance of InAppReviewPlatform.
  ///
  /// This should only be set by the platform-specific implementation.
  static set instance(InAppReviewPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Checks if the device is able to show a review dialog.
  ///
  /// On Android, the Google Play Store must be installed, and the device must be
  /// running **Android 5 Lollipop(API 21)** or higher.
  ///
  /// iOS devices must be running **iOS version 10.3** or higher.
  ///
  /// MacOS devices must be running **MacOS version 10.14** or higher.
  ///
  /// Returns a Future<bool> indicating whether the review dialog is available.
  Future<bool> isAvailable() {
    throw UnimplementedError('isAvailable() has not been implemented.');
  }

  /// Attempts to show the review dialog. It's recommended to first check if
  /// this cannot be done via [isAvailable]. If it is not available, then
  /// you can open the store listing via [openStore].
  ///
  /// To improve the user's experience, iOS and Android enforce limitations
  /// that might prevent this from working after a few tries. iOS & MacOS users
  /// can also disable this feature entirely in the App Store settings.
  ///
  /// More info and guidance:
  /// <br>https://developer.android.com/guide/playcore/in-app-review#when-to-request
  /// <br>https://developer.apple.com/design/human-interface-guidelines/ios/system-capabilities/ratings-and-reviews/
  /// <br>https://developer.apple.com/design/human-interface-guidelines/macos/system-capabilities/ratings-and-reviews/
  ///
  /// Returns a Future<void> indicating the success or failure of showing the review dialog.
  Future<void> requestReview() {
    throw UnimplementedError('requestReview() has not been implemented.');
  }

  /// Opens the Play Store on Android, the App Store with a review
  /// screen on iOS & MacOS, and the Microsoft Store on Windows.
  ///
  /// [appStoreId] is required for iOS & MacOS.
  ///
  /// [microsoftStoreId] is required for Windows.
  ///
  /// Returns a Future<void> indicating the success or failure of opening the store.
  Future<void> openStore({
    /// Required for iOS & MacOS.
    String? appStoreId,
  }) {
    throw UnimplementedError('openStore() has not been implemented.');
  }
}
