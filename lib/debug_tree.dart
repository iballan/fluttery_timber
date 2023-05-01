import 'package:flutter/foundation.dart';
import 'package:fluttery_timber/timber.dart';
import 'package:fluttery_timber/timber_stack_trace.dart';
import 'package:fluttery_timber/timber_tree.dart';
import 'package:intl/intl.dart';

/// Default printer implementation.
/// Prints log-level based colored messages and automatically infers the tag
class DebugTree implements TimberTree {
  static const ansiEsc = '\x1B[';
  static const ansiDefault = '${ansiEsc}0m';
  static const grey = 244;
  static const yellow = 3;
  static const red = 1;
  static const white = 7;
  static const green = 2;
  final dateFormat = DateFormat('hh:mm:ss');

  @override
  void onMessage(
    TimberLevel level,
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    String time = dateFormat.format(DateTime.now());
    tag = tag ?? _getCaller();
    String prefix = '[$time][$tag]';

    message = '${_getLevelEmoji(level)} $message';

    debugPrint('$prefix $message');
    if (stackTrace != null) {
      _debugPrintStack(level, stackTrace);
    }
  }

  String _getCaller() => TimberStackTrace(StackTrace.current).fileName;

  _colorize(int color, String text) =>
      '${ansiEsc}3${color}m$text$ansiDefault';

  String _getLevelEmoji(TimberLevel level) {
    if (level == TimberLevel.warning) {
      return '⚠️';
    } else if (level == TimberLevel.error) {
      return '⛔';
    } else if (level == TimberLevel.info) {
      return '💡';
    } else if (level == TimberLevel.debug) {
      return '🐛';
    }
    return '';
  }

  _debugPrintStack(TimberLevel level, StackTrace stackTrace) {
    stackTrace = FlutterError.demangleStackTrace(stackTrace);

    Iterable<String> lines = stackTrace.toString().trimRight().split('\n');
    if (kIsWeb && lines.isNotEmpty) {
      lines = lines.skipWhile((String line) {
        return line.contains('StackTrace.current') ||
            line.contains('dart-sdk/lib/_internal') ||
            line.contains('dart:sdk_internal');
      });
    }

    int color = grey;
    if (level == TimberLevel.warning) {
      color = yellow;
    } else if (level == TimberLevel.error) {
      color = red;
    }

    debugPrint(
      _colorize(
        color,
        FlutterError.defaultStackFilter(lines).join('\n'),
      ),
    );
  }
}
