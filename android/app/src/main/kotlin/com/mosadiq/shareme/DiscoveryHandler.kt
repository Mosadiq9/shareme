package com.mosadiq.shareme

import android.annotation.SuppressLint
import android.content.Context
import android.net.nsd.NsdManager
import android.net.nsd.NsdServiceInfo
import android.net.wifi.p2p.WifiP2pDevice
import android.net.wifi.p2p.WifiP2pManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.EventChannel
import java.util.UUID

class DiscoveryHandler(private val context: Context) : EventChannel.StreamHandler {

    private var eventSink: EventChannel.EventSink? = null
    private var nsdManager: NsdManager? = null
    private var wifiP2pManager: WifiP2pManager? = null
    private var channel: WifiP2pManager.Channel? = null

    private val discoveredPeers = mutableMapOf<String, Map<String, Any>>()
    private var registrationListener: NsdManager.RegistrationListener? = null
    private var discoveryListener: NsdManager.DiscoveryListener? = null
    private var myDeviceName: String = ""

    companion object {
        const val SERVICE_TYPE = "_shareme._tcp."
    }

    override fun onListen(arguments: Any?, sink: EventChannel.EventSink?) {
        eventSink = sink
    }

    override fun onCancel(arguments: Any?) {
        stopDiscovery()
        eventSink = null
    }

    @SuppressLint("MissingPermission")
    fun startDiscovery(deviceName: String) {
        myDeviceName = deviceName.trim()
        android.util.Log.i("ShareMeDiscovery", "Starting Total Debug Mode Discovery for device: $deviceName")
        discoveredPeers.clear()

        // 1. Start mDNS Service Registration & Discovery
        nsdManager = context.getSystemService(Context.NSD_SERVICE) as? NsdManager
        registerMdnsService(deviceName)
        discoverMdnsServices()

        // 2. Start Wi-Fi Direct Peer Discovery
        wifiP2pManager = context.getSystemService(Context.WIFI_P2P_SERVICE) as? WifiP2pManager
        channel = wifiP2pManager?.initialize(context, Looper.getMainLooper(), null)
        wifiP2pManager?.discoverPeers(channel, object : WifiP2pManager.ActionListener {
            override fun onSuccess() {
                android.util.Log.i("ShareMeDiscovery", "Wi-Fi Direct discoverPeers initiated successfully.")
            }
            override fun onFailure(reasonCode: Int) {
                android.util.Log.w("ShareMeDiscovery", "Wi-Fi Direct discoverPeers failed with reason: $reasonCode")
            }
        })
    }

    fun stopDiscovery() {
        android.util.Log.i("ShareMeDiscovery", "Stopping Discovery.")
        try {
            if (registrationListener != null) {
                nsdManager?.unregisterService(registrationListener)
                registrationListener = null
            }
            if (discoveryListener != null) {
                nsdManager?.stopServiceDiscovery(discoveryListener)
                discoveryListener = null
            }
            wifiP2pManager?.stopPeerDiscovery(channel, null)
        } catch (e: Exception) {
            android.util.Log.e("ShareMeDiscovery", "Error stopping discovery: ${e.message}")
        }
    }

    private fun registerMdnsService(deviceName: String) {
        val serviceInfo = NsdServiceInfo().apply {
            serviceName = "ShareMe_$deviceName"
            serviceType = SERVICE_TYPE
            port = 8888
        }

        registrationListener = object : NsdManager.RegistrationListener {
            override fun onServiceRegistered(NsdServiceInfo: NsdServiceInfo) {
                android.util.Log.i("ShareMeDiscovery", "mDNS Service Registered successfully: ${NsdServiceInfo.serviceName} on port 8888")
            }
            override fun onRegistrationFailed(serviceInfo: NsdServiceInfo, errorCode: Int) {
                android.util.Log.e("ShareMeDiscovery", "mDNS Registration failed: errorCode $errorCode")
            }
            override fun onServiceUnregistered(arg0: NsdServiceInfo) {
                android.util.Log.i("ShareMeDiscovery", "mDNS Service Unregistered.")
            }
            override fun onUnregistrationFailed(serviceInfo: NsdServiceInfo, errorCode: Int) {
                android.util.Log.e("ShareMeDiscovery", "mDNS Unregistration failed: errorCode $errorCode")
            }
        }

        try {
            nsdManager?.registerService(serviceInfo, NsdManager.PROTOCOL_DNS_SD, registrationListener)
        } catch (e: Exception) {
            android.util.Log.e("ShareMeDiscovery", "Exception registering mDNS: ${e.message}")
        }
    }

    private fun discoverMdnsServices() {
        discoveryListener = object : NsdManager.DiscoveryListener {
            override fun onDiscoveryStarted(regType: String) {
                android.util.Log.i("ShareMeDiscovery", "mDNS Service discovery started for regType: $regType")
            }
            override fun onServiceFound(service: NsdServiceInfo) {
                val peerName = service.serviceName.replace("ShareMe_", "").trim()
                if (peerName.equals(myDeviceName, ignoreCase = true) || service.serviceName.equals("ShareMe_$myDeviceName", ignoreCase = true)) {
                    android.util.Log.i("ShareMeDiscovery", "Ignoring self mDNS broadcast: ${service.serviceName}")
                    return
                }
                android.util.Log.i("ShareMeDiscovery", "mDNS Service found: ${service.serviceName} (${service.serviceType})")
                if (service.serviceType.contains("_shareme")) {
                    nsdManager?.resolveService(service, object : NsdManager.ResolveListener {
                        override fun onResolveFailed(serviceInfo: NsdServiceInfo, errorCode: Int) {
                            android.util.Log.e("ShareMeDiscovery", "Resolve failed for ${serviceInfo.serviceName}: $errorCode")
                        }
                        override fun onServiceResolved(serviceInfo: NsdServiceInfo) {
                            val resolvedName = serviceInfo.serviceName.replace("ShareMe_", "").trim()
                            if (resolvedName.equals(myDeviceName, ignoreCase = true)) return
                            val hostIp = serviceInfo.host?.hostAddress ?: serviceInfo.serviceName
                            android.util.Log.i("ShareMeDiscovery", "Resolved mDNS service ${serviceInfo.serviceName} at IP: $hostIp")
                            addOrUpdatePeer(
                                id = hostIp,
                                name = resolvedName,
                                model = "Android • mDNS LAN ($hostIp)",
                                rssi = -50
                            )
                        }
                    })
                }
            }
            override fun onServiceLost(service: NsdServiceInfo) {
                android.util.Log.w("ShareMeDiscovery", "mDNS Service lost: ${service.serviceName}")
                discoveredPeers.entries.removeIf { (k, v) -> (v["name"] as? String) == service.serviceName.replace("ShareMe_", "") }
                emitPeers()
            }
            override fun onDiscoveryStopped(serviceType: String) {
                android.util.Log.i("ShareMeDiscovery", "mDNS Service discovery stopped.")
            }
            override fun onStartDiscoveryFailed(serviceType: String, errorCode: Int) {
                android.util.Log.e("ShareMeDiscovery", "mDNS Start discovery failed: $errorCode")
                nsdManager?.stopServiceDiscovery(this)
            }
            override fun onStopDiscoveryFailed(serviceType: String, errorCode: Int) {
                android.util.Log.e("ShareMeDiscovery", "mDNS Stop discovery failed: $errorCode")
                nsdManager?.stopServiceDiscovery(this)
            }
        }

        try {
            nsdManager?.discoverServices(SERVICE_TYPE, NsdManager.PROTOCOL_DNS_SD, discoveryListener)
        } catch (e: Exception) {
            android.util.Log.e("ShareMeDiscovery", "Exception starting mDNS discovery: ${e.message}")
        }
    }

    private fun addOrUpdatePeer(id: String, name: String, model: String, rssi: Int) {
        val peerMap = mapOf<String, Any>(
            "id" to id,
            "name" to name,
            "deviceModel" to model,
            "signalStrengthRssi" to rssi,
            "supportedBands" to listOf("5GHz", "2.4GHz"),
            "is5GhzSupported" to true
        )
        discoveredPeers[id] = peerMap
        emitPeers()
    }

    private fun emitPeers() {
        Handler(Looper.getMainLooper()).post {
            eventSink?.success(discoveredPeers.values.toList())
        }
    }
}
