import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let METHOD_CHANNEL = "com.mosadiq.shareme/discovery_methods"
  private let EVENT_CHANNEL = "com.mosadiq.shareme/discovery_events"
  private var discoveryManager: AnyObject?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    if #available(iOS 13.0, *) {
      guard let controller = window?.rootViewController as? FlutterViewController else {
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
      }

      let manager = DiscoveryManager()
      discoveryManager = manager

      let eventChannel = FlutterEventChannel(name: EVENT_CHANNEL, binaryMessenger: controller.binaryMessenger)
      eventChannel.setStreamHandler(manager)

      let methodChannel = FlutterMethodChannel(name: METHOD_CHANNEL, binaryMessenger: controller.binaryMessenger)
      methodChannel.setMethodCallHandler({ (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        if call.method == "startDiscovery" {
          if let args = call.arguments as? [String: Any], let deviceName = args["deviceName"] as? String {
            manager.startDiscovery(deviceName: deviceName)
          } else {
            manager.startDiscovery(deviceName: "iOS Device")
          }
          result(nil)
        } else if call.method == "stopDiscovery" {
          manager.stopDiscovery()
          result(nil)
        } else if call.method == "negotiateBand" || call.method == "connectToPeer" {
          result(nil)
        } else {
          result(FlutterMethodNotImplemented)
        }
      })
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
