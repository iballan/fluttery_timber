import 'package:flutter/foundation.dart';
import 'package:fluttery_timber/timber.dart';
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

    if (error != null) {
      message += '\nError: $error';
    }

    debugPrint('$prefix $message');
    if (stackTrace != null) {
      _debugPrintStack(level, stackTrace);
    }
  }

  String _getCaller() => _TimberStackTrace(StackTrace.current).fileName;

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


class _TimberStackTrace {
  final StackTrace _trace;

  String fullFileName = "";
  String fileName = "";
  int lineNumber = 0;
  int columnNumber = 0;

  final levelOutOfTimberStacktrace = 3;
  _TimberStackTrace(this._trace) {
    _parseTrace();
  }

  void _parseTrace() {
    /* The trace comes with multiple lines of strings, we just want the first line, which has the information we need */
    var traceString = _trace.toString().split("\n")[levelOutOfTimberStacktrace];

    /* Search through the string and find the index of the file name by looking for the '.dart' regex */
    var indexOfFileName = traceString.indexOf(RegExp(r'[A-Za-z]+.dart'));

    var fileInfo = traceString.substring(indexOfFileName);

    var listOfInfos = fileInfo.split(":");

    /* Splitting fileInfo by the character ":" separates the file name, the line number and the column counter nicely.
      Example: main.dart:5:12
      To get the file name, we split with ":" and get the first index
      To get the line number, we would have to get the second index
      To get the column number, we would have to get the third index
    */

    fullFileName = listOfInfos[0];
    fileName = fullFileName.replaceAll('.dart', '');
    lineNumber = int.parse(listOfInfos[1]);
    var columnStr = listOfInfos[2];
    columnStr = columnStr.replaceFirst(")", "");
    columnNumber = int.parse(columnStr);
  }
}