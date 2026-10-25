package com.manalogadiel.prayer_wall

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.view.View
import android.widget.RemoteViews
import org.json.JSONArray
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

object PrayerData {
    fun today(): String = SimpleDateFormat("yyyy-MM-dd", Locale.US).format(Date())
    @Synchronized fun change(context: Context, action: String, id: String? = null, item: JSONObject? = null): JSONArray {
        val prefs = context.getSharedPreferences("prayer_widget", Context.MODE_PRIVATE)
        val old = JSONArray(prefs.getString("prayers", "[]"))
        if (action in listOf("add", "edit")) {
            val title = item?.optString("title")?.trim() ?: ""
            require(title.isNotEmpty() && title.length <= 120) { "Invalid prayer title" }
            item?.put("title", title)
        }
        val next = JSONArray()
        for (i in 0 until old.length()) {
            val row = old.getJSONObject(i)
            if (row.optString("id") == id) {
                when (action) {
                    "edit" -> row.put("title", item?.optString("title"))
                    "toggle" -> row.put("date", if (row.optString("date") == today()) "" else today())
                    "pin" -> row.put("pinned", !row.optBoolean("pinned", true))
                    "answer" -> row.put("answered", !row.optBoolean("answered", false))
                    "delete" -> continue
                }
            }
            next.put(row)
        }
        if (action == "add" && item != null && (0 until next.length()).none { next.getJSONObject(it).optString("id") == item.optString("id") }) next.put(item)
        if (action != "load" && !prefs.edit().putString("prayers", next.toString()).commit()) throw IllegalStateException("save failed")
        return next
    }
}

class PrayerWidget : AppWidgetProvider() {
    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) = refresh(context)
    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == "com.manalogadiel.prayer_wall.TOGGLE") {
            try { PrayerData.change(context, "toggle", intent.getStringExtra("id")) } catch (_: Exception) { /* Retain the persisted state on failure. */ }
            refresh(context)
        }
    }
    companion object {
        fun refresh(context: Context) {
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(ComponentName(context, PrayerWidget::class.java))
            if (ids.isEmpty()) return
            val all = try { PrayerData.change(context, "load") } catch (_: Exception) { return }
            val rows = (0 until all.length()).map { all.getJSONObject(it) }.filter { it.optBoolean("pinned", true) && !it.optBoolean("answered", false) }.take(3)
            for (widgetId in ids) {
                val views = RemoteViews(context.packageName, R.layout.prayer_widget)
                val launch = Intent(context, MainActivity::class.java)
                views.setOnClickPendingIntent(R.id.widget_title, PendingIntent.getActivity(context, 0, launch, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE))
                views.setViewVisibility(R.id.widget_empty, if (rows.isEmpty()) View.VISIBLE else View.GONE)
                val rowIds = listOf(R.id.prayer_one, R.id.prayer_two, R.id.prayer_three)
                for (i in rowIds.indices) {
                    views.setViewVisibility(rowIds[i], if (i < rows.size) View.VISIBLE else View.GONE)
                    if (i >= rows.size) continue
                    val p = rows[i]
                    val done = p.optString("date") == PrayerData.today()
                    views.setTextViewText(rowIds[i], "${if (done) "✓" else "○"}   ${p.optString("title")}")
                    views.setContentDescription(rowIds[i], "${p.optString("title")}, ${if (done) "prayed today, tap to undo" else "not prayed today, tap to mark prayed"}")
                    val tap = Intent(context, PrayerWidget::class.java).apply {
                        action = "com.manalogadiel.prayer_wall.TOGGLE"
                        data = android.net.Uri.parse("prayerwall://toggle/${p.optString("id")}")
                        putExtra("id", p.optString("id"))
                    }
                    views.setOnClickPendingIntent(rowIds[i], PendingIntent.getBroadcast(context, widgetId * 10 + i, tap, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE))
                }
                views.setTextViewText(R.id.widget_footer, "${rows.count { it.optString("date") == PrayerData.today() }} of ${rows.size} prayed today · Prayer Wall")
                manager.updateAppWidget(widgetId, views)
            }
        }
    }
}
