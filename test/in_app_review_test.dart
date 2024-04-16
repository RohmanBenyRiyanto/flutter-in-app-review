import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:in_app_review/in_app_review_platform_interface.dart';
import 'package:in_app_review/in_app_review_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockInAppReviewPlatform
    with MockPlatformInterfaceMixin
    implements InAppReviewPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final InAppReviewPlatform initialPlatform = InAppReviewPlatform.instance;

  test('$MethodChannelInAppReview is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelInAppReview>());
  });

  test('getPlatformVersion', () async {
    InAppReview inAppReviewPlugin = InAppReview();
    MockInAppReviewPlatform fakePlatform = MockInAppReviewPlatform();
    InAppReviewPlatform.instance = fakePlatform;

    expect(await inAppReviewPlugin.getPlatformVersion(), '42');
  });
}
