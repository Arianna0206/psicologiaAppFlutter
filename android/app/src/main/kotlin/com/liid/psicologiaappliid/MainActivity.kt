package com.liid.psicologiaappliid

import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle
import android.os.Build
import android.app.NotificationManager
import android.content.Context
import androidx.core.app.NotificationManagerCompat

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            requestPermissions(arrayOf(android.Manifest.permission.POST_NOTIFICATIONS), 0)
        }
    }
}
