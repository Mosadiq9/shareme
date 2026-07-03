package com.mosadiq.shareme.hotspot

import android.annotation.SuppressLint
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.NetworkInfo
import android.net.wifi.p2p.WifiP2pConfig
import android.net.wifi.p2p.WifiP2pDevice
import android.net.wifi.p2p.WifiP2pInfo
import android.net.wifi.p2p.WifiP2pManager
import android.os.Looper
import android.util.Log

class HotspotManager(private val context: Context) {
    private val TAG = "ShareMeHotspot"

    private var wifiP2pManager: WifiP2pManager? = null
    private var channel: WifiP2pManager.Channel? = null
    private var receiver: BroadcastReceiver? = null

    // Callbacks for Flutter
    var onStateChanged: ((String, String?) -> Unit)? = null

    init {
        wifiP2pManager = context.getSystemService(Context.WIFI_P2P_SERVICE) as? WifiP2pManager
        channel = wifiP2pManager?.initialize(context, Looper.getMainLooper(), null)
    }

    @SuppressLint("MissingPermission")
    fun createHotspot() {
        Log.i(TAG, "Creating P2P Group (Hotspot)...")
        
        // Remove existing group if any before creating a new one
        removeGroup {
            registerReceiver()
            val listener = object : WifiP2pManager.ActionListener {
                override fun onSuccess() {
                    Log.i(TAG, "createGroup initiated successfully")
                    onStateChanged?.invoke("creating", null)
                }

                override fun onFailure(reason: Int) {
                    Log.e(TAG, "createGroup failed: $reason")
                    onStateChanged?.invoke("failed", "Failed to create group: $reason")
                }
            }
            
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.Q) {
                try {
                    val config = WifiP2pConfig.Builder()
                        .setGroupOperatingBand(WifiP2pConfig.GROUP_OWNER_BAND_5GHZ)
                        .build()
                    wifiP2pManager?.createGroup(channel, config, listener)
                } catch (e: Exception) {
                    Log.w(TAG, "5GHz Group creation failed, falling back to default", e)
                    wifiP2pManager?.createGroup(channel, listener)
                }
            } else {
                wifiP2pManager?.createGroup(channel, listener)
            }
        }
    }

    @SuppressLint("MissingPermission")
    fun connectToHotspot(deviceAddress: String) {
        Log.i(TAG, "Connecting to Hotspot at $deviceAddress...")
        
        // First ensure we are not in another group
        removeGroup {
            registerReceiver()
            
            val config = WifiP2pConfig().apply {
                this.deviceAddress = deviceAddress
                this.wps.setup = android.net.wifi.WpsInfo.PBC
            }

            wifiP2pManager?.connect(channel, config, object : WifiP2pManager.ActionListener {
                override fun onSuccess() {
                    Log.i(TAG, "connect initiated successfully")
                    onStateChanged?.invoke("connecting", null)
                }

                override fun onFailure(reason: Int) {
                    Log.e(TAG, "connect failed: $reason")
                    onStateChanged?.invoke("failed", "Failed to connect: $reason")
                }
            })
        }
    }

    fun destroyHotspot() {
        Log.i(TAG, "Destroying Hotspot...")
        unregisterReceiver()
        removeGroup {
            onStateChanged?.invoke("idle", null)
        }
    }

    private fun removeGroup(onComplete: () -> Unit) {
        wifiP2pManager?.requestGroupInfo(channel) { group ->
            if (group != null) {
                wifiP2pManager?.removeGroup(channel, object : WifiP2pManager.ActionListener {
                    override fun onSuccess() {
                        Log.i(TAG, "Group removed successfully")
                        onComplete()
                    }
                    override fun onFailure(reason: Int) {
                        Log.w(TAG, "Failed to remove group: $reason")
                        onComplete() // Proceed anyway
                    }
                })
            } else {
                onComplete()
            }
        }
    }

    private fun registerReceiver() {
        if (receiver != null) return
        
        val intentFilter = IntentFilter().apply {
            addAction(WifiP2pManager.WIFI_P2P_STATE_CHANGED_ACTION)
            addAction(WifiP2pManager.WIFI_P2P_CONNECTION_CHANGED_ACTION)
            addAction(WifiP2pManager.WIFI_P2P_THIS_DEVICE_CHANGED_ACTION)
        }

        receiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                when (intent.action) {
                    WifiP2pManager.WIFI_P2P_CONNECTION_CHANGED_ACTION -> {
                        val networkInfo = intent.getParcelableExtra<NetworkInfo>(WifiP2pManager.EXTRA_NETWORK_INFO)
                        val p2pInfo = intent.getParcelableExtra<WifiP2pInfo>(WifiP2pManager.EXTRA_WIFI_P2P_INFO)

                        if (networkInfo?.isConnected == true && p2pInfo != null) {
                            Log.i(TAG, "P2P Connection Established! GO IP: ${p2pInfo.groupOwnerAddress?.hostAddress}")
                            onStateChanged?.invoke("connected", p2pInfo.groupOwnerAddress?.hostAddress)
                        } else {
                            Log.i(TAG, "P2P Connection Disconnected")
                            // We don't auto-send idle here unless requested, as it might just be a temporary blip,
                            // but if disconnected we should probably notify flutter.
                            onStateChanged?.invoke("idle", null)
                        }
                    }
                }
            }
        }
        
        context.registerReceiver(receiver, intentFilter)
    }

    private fun unregisterReceiver() {
        receiver?.let {
            try {
                context.unregisterReceiver(it)
            } catch (e: Exception) {
                Log.e(TAG, "Error unregistering receiver", e)
            }
            receiver = null
        }
    }
}
