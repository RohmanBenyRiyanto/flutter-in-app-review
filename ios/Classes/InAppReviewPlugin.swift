import Flutter
import UIKit
import StoreKit

public class InAppReviewPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "in_app_review", binaryMessenger: registrar.messenger())
    let instance = InAppReviewPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "requestReview":
      requestReview(result)
    case "isAvailable":
      isAvailable(result)
    case "openStore":
      if let storeId = call.arguments as? String {
        openStore(withStoreId: storeId, result: result)
      } else {
        result(FlutterError(code: "no-store-id", message: "Your store id must be passed as the method channel's argument", details: nil))
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func requestReview(_ result: @escaping FlutterResult) {
    if #available(iOS 14.0, *) {
      if let scene = findActiveScene() {
        SKStoreReviewController.requestReview(in: scene)
        result(nil)
      } else {
        result(FlutterError(code: "scene-not-found", message: "Active scene not found", details: nil))
      }
    } else if #available(iOS 10.3, *) {
      SKStoreReviewController.requestReview()
      result(nil)
    } else {
      result(FlutterError(code: "unavailable", message: "In-App Review unavailable", details: nil))
    }
  }

  private func isAvailable(_ result: @escaping FlutterResult) {
    if #available(iOS 10.3, *) {
      result(true)
    } else {
      result(false)
    }
  }

  private func openStore(withStoreId storeId: String, result: @escaping FlutterResult) {
    guard let url = URL(string: "https://apps.apple.com/app/id\(storeId)?action=write-review") else {
      result(FlutterError(code: "url-construct-fail", message: "Failed to construct url", details: nil))
      return
    }

    UIApplication.shared.open(url, options: [:]) { success in
      if success {
        result(nil)
      } else {
        result(FlutterError(code: "open-url-fail", message: "Failed to open URL", details: nil))
      }
    }
  }

  private func findActiveScene() -> UIWindowScene? {
    if #available(iOS 13.0, *) {
      for scene in UIApplication.shared.connectedScenes {
        if let windowScene = scene as? UIWindowScene, windowScene.activationState == .foregroundActive {
          return windowScene
        }
      }
    }
    return nil
  }
}
