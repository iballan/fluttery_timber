import 'package:flutter_test/flutter_test.dart';

import 'package:fluttery_timber/timber.dart';

void main() {
  test('adds one to input values', () {
    Timber.i("Log message");
  });
}
