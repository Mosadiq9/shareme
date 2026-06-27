import Foundation
import Network
import Flutter

@available(iOS 13.0, *)
class DiscoveryManager: NSObject, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    private var listener: NWListener?
    private var browser: NWBrowser?
    private var discoveredPeers: [String: [String: Any]] = [:]

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        stopDiscovery()
        self.eventSink = nil
        return nil
    }

    func startDiscovery(deviceName: String) {
        discoveredPeers.removeAll()

        // 1. Start NWListener advertising _shareme._tcp
        do {
            listener = try NWListener(using: .tcp)
            listener?.service = NWListener.Service(name: "ShareMe_\(deviceName)", type: "_shareme._tcp")
            listener?.stateUpdateHandler = { newState in
                // Handle listener state changes if needed
            }
            listener?.start(queue: .main)
        } catch {
            // Port blocked or network restricted
        }

        // 2. Start NWBrowser looking for _shareme._tcp
        let descriptor = NWBrowser.Descriptor.bonjour(type: "_shareme._tcp", domain: "local.")
        browser = NWBrowser(for: descriptor, using: .tcp)
        browser?.browseResultsChangedHandler = { [weak self] results, changes in
            guard let self = self else { return }
            for result in results {
                if case let NWEndpoint.service(name, _, _, _) = result.endpoint {
                    let cleanName = name.replacingOccurrences(of: "ShareMe_", with: "")
                    let peerMap: [String: Any] = [
                        "id": name,
                        "name": cleanName,
                        "deviceModel": "iOS • Bonjour LAN",
                        "signalStrengthRssi": -45,
                        "supportedBands": ["5GHz", "2.4GHz"],
                        "is5GhzSupported": true
                    ]
                    self.discoveredPeers[name] = peerMap
                }
            }
            self.emitPeers()
        }
        browser?.start(queue: .main)
    }

    func stopDiscovery() {
        listener?.cancel()
        listener = nil
        browser?.cancel()
        browser = nil
    }

    private func emitPeers() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.eventSink?(Array(self.discoveredPeers.values))
        }
    }
}
