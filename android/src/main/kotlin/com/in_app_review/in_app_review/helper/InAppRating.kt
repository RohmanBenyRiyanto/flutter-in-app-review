 package com.in_app_review.in_app_review.helper

 import android.annotation.SuppressLint
 import android.app.Activity
 import android.content.ActivityNotFoundException
 import android.content.Context
 import android.content.Intent
 import android.content.pm.PackageManager
 import android.net.Uri
 import android.os.Build
 import android.util.Log
 import com.google.android.gms.common.ConnectionResult
 import com.google.android.gms.common.GoogleApiAvailability
 import com.google.android.gms.tasks.Task
 import com.google.android.play.core.review.ReviewInfo
 import com.google.android.play.core.review.ReviewManager
 import com.google.android.play.core.review.ReviewManagerFactory
 import com.in_app_review.in_app_review.R
 import io.flutter.plugin.common.MethodChannel.Result

 class InAppRating(private val context: Context, private val activity: Activity) {

     private var reviewInfo: ReviewInfo? = null
     private val tag = context.getString(R.string.app_name)
     @SuppressLint("ObsoleteSdkInt")
     fun isAvailable(result: Result) {
         Log.i(tag, "isAvailable: called")
         if (noContextOrActivity(result)) return

         val playStoreAndPlayServicesAvailable = isPlayStoreAndPlayServicesAvailable()
         val lollipopOrLater = Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP

         Log.i(tag, "isAvailable: playStoreAndPlayServicesAvailable: $playStoreAndPlayServicesAvailable")
         Log.i(tag, "isAvailable: lollipopOrLater: $lollipopOrLater")

         if (!(playStoreAndPlayServicesAvailable && lollipopOrLater)) {
             Log.w(tag, "isAvailable: The Play Store must be installed, Play Services must be available, and Android 5 or later must be used")
             result.success(false)
         } else {
             Log.i(tag, "isAvailable: Play Store, Play Services, and Android version requirements met")
             cacheReviewInfo(result)
         }
     }

     private fun cacheReviewInfo(result: Result) {
         Log.i(tag, "cacheReviewInfo: called")
         if (noContextOrActivity(result)) return

         try {
             val manager: ReviewManager = ReviewManagerFactory.create(context)
             val request: Task<ReviewInfo> = manager.requestReviewFlow()

             Log.i(tag, "cacheReviewInfo: Requesting review flow")
             request.addOnCompleteListener { task ->
                 try {
                     if (task.isSuccessful) {
                         // We can get the ReviewInfo object
                         Log.i(tag, "onComplete: Successfully requested review flow")
                         reviewInfo = task.result
                         result.success(true)
                     } else {
                         // The API isn't available
                         Log.w(tag, "onComplete: Unsuccessfully requested review flow")
                         result.success(false)
                     }
                 } catch (e: Exception) {
                     Log.e(tag, "Exception in cacheReviewInfo: $e")
                     result.error("error", "Error in cacheReviewInfo", null)
                 }
             }
         } catch (e: Exception) {
             Log.e(tag, "Exception in cacheReviewInfo: $e")
             result.error("error", "Error in cacheReviewInfo", null)
         }
     }

     fun requestReview(result: Result) {
         Log.i(tag, "requestReview: called")
         if (noContextOrActivity(result)) return

         try {
             val manager: ReviewManager = ReviewManagerFactory.create(context)

             if (reviewInfo != null) {
                 launchReviewFlow(result, manager, reviewInfo!!)
                 return
             }

             val request: Task<ReviewInfo> = manager.requestReviewFlow()

             Log.i(tag, "requestReview: Requesting review flow")
             request.addOnCompleteListener { task ->
                 try {
                     if (task.isSuccessful) {
                         // We can get the ReviewInfo object
                         Log.i(tag, "onComplete: Successfully requested review flow")
                         val reviewInfo = task.result
                         launchReviewFlow(result, manager, reviewInfo)
                     } else {
                         Log.w(tag, "onComplete: Unsuccessfully requested review flow")
                         result.error("error", "In-App Review API unavailable", null)
                     }
                 } catch (e: Exception) {
                     Log.e(tag, "Exception in requestReview: $e")
                     result.error("error", "Error in requestReview", null)
                 }
             }
         } catch (e: Exception) {
             Log.e(tag, "Exception in requestReview: $e")
             result.error("error", "Error in requestReview", null)
         }
     }

     private fun launchReviewFlow(result: Result, manager: ReviewManager, reviewInfo: ReviewInfo) {
         Log.i(tag, "launchReviewFlow: called")
         if (noContextOrActivity(result)) return

         try {
             val flow: Task<Void> = manager.launchReviewFlow(activity, reviewInfo)
             flow.addOnCompleteListener { result.success(null) }
         } catch (e: Exception) {
             Log.e(tag, "Exception in launchReviewFlow: $e")
             result.error("error", "Error in launchReviewFlow", null)
         }
     }

     private fun isPlayStoreAndPlayServicesAvailable(): Boolean {
         try {
             context.packageManager.getPackageInfo("com.android.vending", 0)
         } catch (e: PackageManager.NameNotFoundException) {
             Log.i(tag, "Play Store not installed.")
             return false
         }

         val availability: GoogleApiAvailability = GoogleApiAvailability.getInstance()
         if (availability.isGooglePlayServicesAvailable(context) != ConnectionResult.SUCCESS) {
             Log.i(tag, "Google Play Services not available")
             return false
         }

         return true
     }

     fun openStore(appId: String?) {
         if (appId.isNullOrBlank()) {
             Log.e(tag, "openStore: App ID is null or blank")
             return
         }
         try {
             context.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=$appId")))
         } catch (e: ActivityNotFoundException) {
             context.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse("https://play.google.com/store/apps/details?id=$appId")))
         } catch (e: Exception) {
             Log.e(tag, "Exception in openStore: $e")
         }
     }

     private fun noContextOrActivity(result: Result): Boolean {
         Log.i(tag, "noContextOrActivity: called")
         return if (context == null) {
             Log.e(tag, "noContextOrActivity: Android context not available")
             result.error("error", "Android context not available", null)
             true
         } else if (activity == null) {
             Log.e(tag, "noContextOrActivity: Android activity not available")
             result.error("error", "Android activity not available", null)
             true
         } else {
             false
         }
     }
 }
