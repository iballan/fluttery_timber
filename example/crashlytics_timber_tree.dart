import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:fluttery_timber/timber.dart';
import 'package:fluttery_timber/timber_tree.dart';

class CrashlyticsTimberTree implements TimberTree {
  @override
  void onMessage(TimberLevel level, String message,
      {String? tag, error, StackTrace? stackTrace}) {
    if (level != TimberLevel.error) return; // Log only errors to crashlytics
    FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      reason: message,
    );
  }
}
