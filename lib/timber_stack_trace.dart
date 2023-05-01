
class TimberStackTrace {
  final StackTrace _trace;

  String fullFileName = "";
  String fileName = "";
  int lineNumber = 0;
  int columnNumber = 0;

  final levelOutOfTimberStacktrace = 3;
  TimberStackTrace(this._trace) {
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