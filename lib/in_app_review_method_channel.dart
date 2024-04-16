import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'in_app_review_platform_interface.dart';

/// An implementation of [InAppReviewPlatform] that uses method channels.
class MethodChannelInAppReview extends InAppReviewPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('in_app_review');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
