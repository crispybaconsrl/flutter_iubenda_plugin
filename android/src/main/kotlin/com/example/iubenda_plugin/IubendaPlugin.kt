package com.example.iubenda_plugin

import android.app.Activity
import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import org.json.JSONObject


/** IubendaPlugin */
class IubendaPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    PluginRegistry.ActivityResultListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var activity: Activity
    private var activityBinding: ActivityPluginBinding? = null
    private  var consentResult: Result? = null
    private val CHECK_CONSENT_FROM_IUBENDA = 367

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "iubenda_plugin")
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "check_consent" -> {
                var arguments = call.arguments<HashMap<String, Any>>()
                val siteId: String = arguments?.get("siteId") as String
                val cookiesId: String = arguments?.get("cookiesId") as String
                val showPreferences: Boolean = arguments?.get("showPreferences") as Boolean
                consentResult = result;
                if (activity.applicationContext != null) {
                    val intent = Intent(activity.applicationContext, Iub::class.java)
                    intent.putExtra("siteId", siteId)
                    intent.putExtra("cookiesId", cookiesId)
                    intent.putExtra("showPreferences", showPreferences)
                    activity.startActivityForResult(intent, CHECK_CONSENT_FROM_IUBENDA)
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityBinding = binding
        binding.addActivityResultListener(this)
        channel.setMethodCallHandler(this)
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activityBinding?.removeActivityResultListener(this)
        activityBinding = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        activityBinding?.removeActivityResultListener(this)
        activityBinding = null
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == CHECK_CONSENT_FROM_IUBENDA) {
            if (resultCode == Activity.RESULT_OK) {
                print(data)
                if (data != null && consentResult != null) {
                    val consentValue = data.getBooleanExtra("consent_key", false)
                    val isGoogleAdsPersonalised = data.getBooleanExtra("google_ads_key", false)
                    var json = JSONObject()
                    json.put("consent", consentValue)
                    json.put("google_ads",isGoogleAdsPersonalised)

                    consentResult!!.success(json.toString())
                    consentResult = null
                    return consentValue;
                }
            }
        }
        return false
    }
}