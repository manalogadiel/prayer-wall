package com.manalogadiel.prayer_wall

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.os.Build
import org.json.JSONObject

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "prayer_wall/widget").setMethodCallHandler { call, result ->
            try {
                if (call.method == "pinWidget") {
                    val manager = AppWidgetManager.getInstance(this)
                    result.success(Build.VERSION.SDK_INT >= 26 && manager.isRequestPinAppWidgetSupported && manager.requestPinAppWidget(ComponentName(this, PrayerWidget::class.java), null, null))
                } else if (call.method in listOf("load", "add", "edit", "toggle", "pin", "answer", "delete")) {
                    val item = call.argument<Map<String, Any?>>("item")?.let { JSONObject(it) }
                    result.success(PrayerData.change(this, call.method, call.argument<String>("id"), item).toString())
                    PrayerWidget.refresh(this)
                } else result.notImplemented()
            } catch (e: Exception) { result.error("storage", "Could not save prayer data", null) }
        }
    }
}
