package com.in_app_review.in_app_review.helper

 import android.content.Context
 import com.in_app_review.in_app_review.R
 import io.flutter.plugin.common.MethodCall
 import io.flutter.plugin.common.MethodChannel
 import kotlinx.coroutines.DelicateCoroutinesApi
 import kotlinx.coroutines.Dispatchers
 import kotlinx.coroutines.GlobalScope
 import kotlinx.coroutines.launch

 class InAppRatingHandler(private val inAppRating: InAppRating, private val context: Context) : MethodChannel.MethodCallHandler {
     override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
         when (call.method) {
             context.getString(R.string.method_is_available) -> handleIsAvailable(result)
             context.getString(R.string.method_request_review) -> handleRequestReview(result)
             context.getString(R.string.method_open_store) -> handleOpenStore(call, result)
             else -> result.notImplemented()
         }
     }

     @OptIn(DelicateCoroutinesApi::class)
     private fun handleIsAvailable(result: MethodChannel.Result) {
         GlobalScope.launch(Dispatchers.Main) {
             try {
                 inAppRating.isAvailable(result)
             } catch (e: Exception) {
                 result.error("ERROR_CODE", "Error checking in-app rating availability", null)
             }
         }
     }

     @OptIn(DelicateCoroutinesApi::class)
     private fun handleRequestReview(result: MethodChannel.Result) {
         GlobalScope.launch(Dispatchers.Main) {
             try {
                 inAppRating.requestReview(result)
             } catch (e: Exception) {
                 result.error("ERROR_CODE", "Error requesting in-app review", null)
             }
         }
     }

     private fun handleOpenStore(call: MethodCall, result: MethodChannel.Result) {
         try {
             val appId: String? = call.argument("appId")
             if (!appId.isNullOrBlank()) {
                 inAppRating.openStore(appId)
                 result.success(true)
             } else {
                 result.error("ERROR_CODE", "App ID is null or blank", null)
             }
         } catch (e: Exception) {
             result.error("ERROR_CODE", "Error opening store", null)
         }
     }
 }
