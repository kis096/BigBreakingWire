package com.bigbreakingwire.app

import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    
    private val channelName = "com.bigbreakingwire.app/deepLinkChannel" // Channel for deep link communication

    // Use 'override' to ensure correct method overriding
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent) // Call the superclass implementation
        // Check if the intent has a data URI
        intent.data?.let { uri ->
            handleDeepLink(uri) // Handle the deep link
        }
    }

    private fun handleDeepLink(uri: Uri) {
        val path = uri.path // Extract the path from the URI

        // Use MethodChannel to communicate with Flutter
        val channel = MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger ?: return, channelName)
        channel.invokeMethod("handleDeepLink", path) // Send the path to Flutter
    }

    // Method to open Play Store if the app is not installed
    private fun openPlayStore() {
        val appPackageName = "com.bigbreakingwire.app" // Your app's package name
        try {
            startActivity(Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=$appPackageName")))
        } catch (anfe: android.content.ActivityNotFoundException) {
            startActivity(Intent(Intent.ACTION_VIEW, Uri.parse("https://play.google.com/store/apps/details?id=$appPackageName")))
        }
    }
}
