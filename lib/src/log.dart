const psdEnableLogging = true;

void psdWarning(List<String> args) {
  if (psdEnableLogging) {
    final channel = args[0];
    final msg = args.sublist(1).reduce((value, element) => '$value $element');
    setLastError(msg);
    print('***WARNING*** [$channel] $msg');
  }
}

void psdError(List<String> args) {
  if (psdEnableLogging) {
    final channel = args[0];
    final msg = args.sublist(1).reduce((value, element) => '$value $element');
    setLastError(msg);
    print('***ERROR*** [$channel] $msg');
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
