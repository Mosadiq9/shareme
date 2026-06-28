package com.mosadiq.shareme

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import com.mosadiq.shareme.hotspot.HotspotManager

class MainActivity : FlutterActivity() {
    private val METHOD_CHANNEL = "com.mosadiq.shareme/discovery_methods"
    private val EVENT_CHANNEL = "com.mosadiq.shareme/discovery_events"
    private val HOTSPOT_EVENT_CHANNEL = "com.mosadiq.shareme/hotspot_events"
    
    private var discoveryHandler: DiscoveryHandler? = null
    private var hotspotManager: HotspotManager? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        discoveryHandler = DiscoveryHandler(applicationContext)
        hotspotManager = HotspotManager(applicationContext)

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
            discoveryHandler
        )
        
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, HOTSPOT_EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    hotspotManager?.onStateChanged = { status, ip ->
                        val map = mapOf("status" to status, "ip" to ip)
                        events?.success(map)
                    }
                }
                override fun onCancel(arguments: Any?) {
                    hotspotManager?.onStateChanged = null
                }
            }
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
                    // Band negotiation is handled inherently by Wi-Fi Direct. 
                    result.success(null)
                }
                "createHotspot" -> {
                    hotspotManager?.createHotspot()
                    result.success(null)
                }
                "connectToHotspot" -> {
                    val deviceAddress = call.argument<String>("deviceAddress")
                    if (deviceAddress != null) {
                        hotspotManager?.connectToHotspot(deviceAddress)
                        result.success(null)
                    } else {
                        result.error("INVALID_ARG", "deviceAddress is required", null)
                    }
                }
                "destroyHotspot" -> {
                    hotspotManager?.destroyHotspot()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }
}
