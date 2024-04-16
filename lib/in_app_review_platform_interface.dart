import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'in_app_review_method_channel.dart';

abstract class InAppReviewPlatform extends PlatformInterface {
  /// Constructs a InAppReviewPlatform.
  InAppReviewPlatform() : super(token: _token);

  static final Object _token = Object();

  static InAppReviewPlatform _instance = MethodChannelInAppReview();

  /// The default instance of [InAppReviewPlatform] to use.
  ///
  /// Defaults to [MethodChannelInAppReview].
  static InAppReviewPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [InAppReviewPlatform] when
  /// they register themselves.
  static set instance(InAppReviewPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
