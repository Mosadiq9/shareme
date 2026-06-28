package com.mosadiq.shareme

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val METHOD_CHANNEL = "com.mosadiq.shareme/discovery_methods"
    private val EVENT_CHANNEL = "com.mosadiq.shareme/discovery_events"
    private var discoveryHandler: DiscoveryHandler? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        discoveryHandler = DiscoveryHandler(applicationContext)

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
            discoveryHandler
        )

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startDiscovery" -> {
                    val deviceName = call.argument<String>("deviceName") ?: "Android Device"
                    val uuid = call.argument<String>("uuid") ?: ""
                    discoveryHandler?.startDiscovery(deviceName, uuid)
                    result.success(null)
                }
                "stopDiscovery" -> {
                    discoveryHandler?.stopDiscovery()
                    result.success(null)
                }
                "negotiateBand" -> {
                    val peerId = call.argument<String>("peerId")
                    val band = call.argument<String>("band")
                    // In real Android Wi-Fi Direct, WifiP2pConfig is configured here
                    result.success(null)
                }
                "connectToPeer" -> {
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }
}
