/// Function signature for custom log handlers
typedef LogHandler = void Function(
    String level, String channel, String message);

var psdEnableLogging = false;
LogHandler? _customLogHandler;

/// Sets a custom log handler for PSD SDK logging
///
/// Example:
/// ```dart
/// PsdLogger.setLogHandler((level, channel, message) {
///   print('[$level] $channel: $message');
/// });
/// ```
void setLogHandler(LogHandler? handler) {
  _customLogHandler = handler;
}

void psdWarning(List<String> args) {
  if (psdEnableLogging) {
    final channel = args[0];
    final msg = args.sublist(1).reduce((value, element) => '$value $element');
    setLastError(msg);

    if (_customLogHandler != null) {
      _customLogHandler!('WARNING', channel, msg);
    }
  }
}

void psdError(List<String> args) {
  if (psdEnableLogging) {
    final channel = args[0];
    final msg = args.sublist(1).reduce((value, element) => '$value $element');
    setLastError(msg);

    if (_customLogHandler != null) {
      _customLogHandler!('ERROR', channel, msg);
    }
  }
}

var lastError = '';

void setLastError(String err) {
  lastError = err;
}

String popLastError([String defaultVal = 'Unknown error']) {
  final err = lastError.isEmpty ? defaultVal : lastError;
  lastError = '';
  return err;
}

void enableLogging() {
  psdEnableLogging = true;
}

void disableLogging() {
  psdEnableLogging = false;
}
