
import 'in_app_review_platform_interface.dart';

class InAppReview {
  Future<String?> getPlatformVersion() {
    return InAppReviewPlatform.instance.getPlatformVersion();
  }
}
