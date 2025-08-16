import 'log.dart' as log;

/// Function signature for custom log handlers
typedef LogHandler = void Function(
    String level, String channel, String message);

/// A public interface for controlling logging functionality in the PSD SDK.
///
/// This class provides static methods to enable or disable logging for the entire
/// PSD SDK, and allows setting custom log handlers for better integration with
/// application logging systems.
///
/// Logging is disabled by default to maintain optimal performance. Enable logging
/// only when debugging or when detailed error information is needed.
///
/// Example usage:
/// ```dart
/// // Enable logging with default behavior (silent unless custom handler set)
/// PsdLogging.enable();
///
/// // Set a custom log handler
/// PsdLogging.setLogHandler((level, channel, message) {
///   print('[$level] $channel: $message');
/// });
///
/// // Disable logging when no longer needed
/// PsdLogging.disable();
/// ```
class PsdLogging {
  /// Enables logging for the PSD SDK.
  ///
  /// When enabled, the following will be logged:
  /// - Warning messages via [psdWarning]
  /// - Error messages via [psdError]
  ///
  /// Logged messages will be:
  /// 1. Passed to the custom log handler if one is set
  /// 2. Stored in the error buffer for later retrieval via [popLastError]
  ///
  /// Note: Logging is disabled by default for performance reasons. Only enable
  /// logging when debugging or when detailed error information is needed.
  static void enable() {
    log.enableLogging();
  }

  /// Disables logging for the PSD SDK.
  ///
  /// When disabled:
  /// - Warning and error messages will not be processed
  /// - The error buffer will not be updated
  /// - Performance will be optimized
  ///
  /// This is the default state of the SDK and should be used in production
  /// environments where logging is not needed.
  static void disable() {
    log.disableLogging();
  }

  /// Sets a custom log handler for PSD SDK logging.
  ///
  /// The handler will receive all log messages when logging is enabled.
  /// Set to null to remove the custom handler.
  ///
  /// Parameters:
  /// - [handler]: Function that receives (level, channel, message) or null
  ///
  /// Example:
  /// ```dart
  /// PsdLogging.setLogHandler((level, channel, message) {
  ///   print('PSD SDK [$level] $channel: $message');
  /// });
  /// ```
  static void setLogHandler(LogHandler? handler) {
    log.setLogHandler(handler);
  }

  /// Gets the last error message from the PSD SDK.
  ///
  /// Returns the most recent error message or [defaultValue] if no error
  /// has occurred. Calling this method clears the error buffer.
  ///
  /// Parameters:
  /// - [defaultValue]: Value to return if no error exists (default: 'Unknown error')
  ///
  /// Returns the last error message as a string.
  static String getLastError([String defaultValue = 'Unknown error']) {
    return log.popLastError(defaultValue);
  }
}
