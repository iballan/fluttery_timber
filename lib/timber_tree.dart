
import 'package:fluttery_timber/timber.dart';

abstract class TimberTree {
  void onMessage(
      TimberLevel level,
      String message, {
        String? tag,
        dynamic error,
        StackTrace? stackTrace,
      });
}