
Another Android Timber-like Flutter Package. I use Fluttery Timber in my projects. Hope you find it useful.

## Features

* Log to local with fila name and date when in `Debug`
* Log to Error reporting system (I use F.B crashlytics) when in Production.
* EASY TO USE

## Getting started

Add the package to your pubspec:

```dart
fluttery_timber:
```


## Usage

Early after the app starts and BEFORE you log any message:

```dart
Timber.i("Message");
try {
  // error throwing code
} catch (e, stack) {
  Timber.e("Message", error: e, stackTrace: stack)
}

```

### Example
```dart
void setupLogger() {
    if (kDebugMode) {
      Timber.plantTree(DebugTree());
    } else {
      Timber.plantTree(CrashlyticsTimberTree());
    }
}

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
```

## Additional information

Hope you find it useful!