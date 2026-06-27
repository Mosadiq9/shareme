# ShareMe — ProGuard / R8 Obfuscation & Shrinking Rules
# Ensures native bindings and reflection-dependent frameworks are preserved in release APKs (TRD §9.2).

# Preserve Flutter engine wrappers
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Preserve Drift & SQLite native C library bindings (sqlite3_flutter_libs)
-keep class org.sqlite.** { *; }
-keep class com.almworks.sqlite4java.** { *; }
-keep class io.flutter.plugins.sqlite3_flutter_libs.** { *; }

# Keep models used by Riverpod or serializable data objects
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Prevent stripping of MethodChannel handlers
-keepclassmembers class * {
    @io.flutter.plugin.common.MethodChannel$MethodCallHandler <methods>;
}

# Ignore warnings for optional libraries
-dontwarn io.flutter.**
-dontwarn org.sqlite.**
