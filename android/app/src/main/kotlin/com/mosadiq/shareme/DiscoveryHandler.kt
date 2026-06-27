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
        discoveredPeers.clear()

        // 1. Start mDNS Service Registration & Discovery
        nsdManager = context.getSystemService(Context.NSD_SERVICE) as? NsdManager
        registerMdnsService(deviceName)
        discoverMdnsServices()

        // 2. Start Wi-Fi Direct Peer Discovery
        wifiP2pManager = context.getSystemService(Context.WIFI_P2P_SERVICE) as? WifiP2pManager
        channel = wifiP2pManager?.initialize(context, Looper.getMainLooper(), null)
        wifiP2pManager?.discoverPeers(channel, object : WifiP2pManager.ActionListener {
            override fun onSuccess() {}
            override fun onFailure(reasonCode: Int) {}
        })
    }

    fun stopDiscovery() {
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
            // Ignore stop errors
        }
    }

    private fun registerMdnsService(deviceName: String) {
        val serviceInfo = NsdServiceInfo().apply {
            serviceName = "ShareMe_$deviceName"
            serviceType = SERVICE_TYPE
            port = 8888
        }

        registrationListener = object : NsdManager.RegistrationListener {
            override fun onServiceRegistered(NsdServiceInfo: NsdServiceInfo) {}
            override fun onRegistrationFailed(serviceInfo: NsdServiceInfo, errorCode: Int) {}
            override fun onServiceUnregistered(arg0: NsdServiceInfo) {}
            override fun onUnregistrationFailed(serviceInfo: NsdServiceInfo, errorCode: Int) {}
        }

        try {
            nsdManager?.registerService(serviceInfo, NsdManager.PROTOCOL_DNS_SD, registrationListener)
        } catch (e: Exception) {
            // Service already registered or blocked
        }
    }

    private fun discoverMdnsServices() {
        discoveryListener = object : NsdManager.DiscoveryListener {
            override fun onDiscoveryStarted(regType: String) {}
            override fun onServiceFound(service: NsdServiceInfo) {
                if (service.serviceType.contains("_shareme")) {
                    nsdManager?.resolveService(service, object : NsdManager.ResolveListener {
                        override fun onResolveFailed(serviceInfo: NsdServiceInfo, errorCode: Int) {}
                        override fun onServiceResolved(serviceInfo: NsdServiceInfo) {
                            addOrUpdatePeer(
                                id = serviceInfo.serviceName,
                                name = serviceInfo.serviceName.replace("ShareMe_", ""),
                                model = "Android • mDNS LAN",
                                rssi = -50
                            )
                        }
                    })
                }
            }
            override fun onServiceLost(service: NsdServiceInfo) {
                discoveredPeers.remove(service.serviceName)
                emitPeers()
            }
            override fun onDiscoveryStopped(serviceType: String) {}
            override fun onStartDiscoveryFailed(serviceType: String, errorCode: Int) {
                nsdManager?.stopServiceDiscovery(this)
            }
            override fun onStopDiscoveryFailed(serviceType: String, errorCode: Int) {
                nsdManager?.stopServiceDiscovery(this)
            }
        }

        try {
            nsdManager?.discoverServices(SERVICE_TYPE, NsdManager.PROTOCOL_DNS_SD, discoveryListener)
        } catch (e: Exception) {}
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
