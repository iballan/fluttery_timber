
import 'package:fluttery_timber/timber_tree.dart';

import 'debug_tree.dart';

enum TimberLevel { info, debug, warning, error }

class Timber {
  static TimberTree _tree = DebugTree();

  /// Global Timber log level
  static TimberLevel logLevel = TimberLevel.info;

  /// Adds a tree to Timber
  static plantTree(TimberTree tree) {
    _tree = tree;
  }

  /// Prints a info message on each installed tree.
  /// It does nothing if Timber.logLevel is debug, warning or error
  static i(String message) {
    if (logLevel.index > TimberLevel.info.index) return;
    _tree.onMessage(TimberLevel.info, message);
  }

  /// Prints a debug message on each installed tree.
  /// It does nothing if Timber.logLevel is warning or error
  static d(String message) {
    if (logLevel.index > TimberLevel.debug.index) return;
    _tree.onMessage(TimberLevel.debug, message);
  }

  /// Prints a warning message on each installed tree.
  /// It does nothing if Timber.logLevel is error
  static w(String message) {
    if (logLevel.index > TimberLevel.warning.index) return;
    _tree.onMessage(TimberLevel.warning, message);
  }

  /// Prints an error message on each installed tree.
  static e(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _tree.onMessage(
      TimberLevel.error,
      message,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
