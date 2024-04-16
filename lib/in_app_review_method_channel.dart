import 'package:flutter/foundation.dart';
import 'package:platform/platform.dart';
import 'package:flutter/services.dart';

import 'in_app_review_platform_interface.dart';

/// The implementation of the [InAppReviewPlatform] interface using [MethodChannel].
///
/// This class provides functionality for evaluating whether the system supports
/// in-app review feature, requesting reviews from users, and opening the app store
/// for reviewing or rating the app.
class MethodChannelInAppReview extends InAppReviewPlatform {
  // Method channel for communication between Dart and native code.
  MethodChannel _channel = const MethodChannel('in_app_review');

  // Platform information for determining the operating system.
  Platform _platform = const LocalPlatform();

  /// For testing purposes, allows injecting a mock [MethodChannel].
  @visibleForTesting
  set channel(MethodChannel channel) => _channel = channel;

  /// For testing purposes, allows injecting a mock [Platform].
  @visibleForTesting
  set platform(Platform platform) => _platform = platform;

  /// Checks whether the in-app review feature is available on the current platform.
  ///
  /// Returns `true` if the feature is available, otherwise `false`.
  ///
  /// On the web platform, in-app review is not supported, so this method always returns `false`.
  @override
  Future<bool> isAvailable() async {
    if (kIsWeb) return false;

    return _channel
        .invokeMethod<bool>('isAvailable')
        .then((available) => available ?? false, onError: (_) => false);
  }

  /// Requests a review from the user.
  ///
  /// This method triggers the native in-app review flow to prompt the user to leave a review.
  @override
  Future<void> requestReview() => _channel.invokeMethod('requestReview');

  /// Opens the app store for reviewing or rating the app.
  ///
  /// [appStoreId] is the unique identifier for the app on the app store.
  ///
  /// On iOS, it opens the App Store page for the app with the given [appStoreId].
  /// On Android, it opens the Google Play Store page for the app with the given [appStoreId].
  ///
  /// Throws [UnsupportedError] if the platform is not supported.
  @override
  Future<void> openStore({
    String? appStoreId,
  }) async {
    final bool isiOS = _platform.isIOS;
    final bool isAndroid = _platform.isAndroid;

    if (isiOS || isAndroid) {
      await _channel.invokeMethod(
        'openStore',
        {"appId": appStoreId},
      );
    } else {
      throw UnsupportedError(
        'Platform(${_platform.operatingSystem}) not supported',
      );
    }
  }
}
