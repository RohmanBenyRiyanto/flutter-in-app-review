package com.in_app_review.in_app_review

import android.app.Activity
import android.content.Context
import com.in_app_review.in_app_review.helper.InAppRating
import com.in_app_review.in_app_review.helper.InAppRatingHandler
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class InAppReviewPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private var activity: Activity? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, context.getString(R.string.in_app_review))
        channel.setMethodCallHandler(this)
    }

    override fun onAttachedToActivity(activityPluginBinding: ActivityPluginBinding) {
        activity = activityPluginBinding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (activity == null) {
            result.error("NO_ACTIVITY", "Activity not available", null)
            return
        }

        val inAppRating = InAppRating(context, activity!!)
        val handler = InAppRatingHandler(inAppRating, context)
        handler.onMethodCall(call, result)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
