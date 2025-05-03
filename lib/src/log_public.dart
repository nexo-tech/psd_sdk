import 'log.dart';

/// A public interface for controlling logging functionality in the PSD SDK.
///
/// This class provides static methods to enable or disable logging for the entire
/// PSD SDK. When logging is enabled, warning and error messages will be printed
/// to the console and stored in the error buffer.
///
/// Logging is disabled by default to maintain optimal performance. Enable logging
/// only when debugging or when detailed error information is needed.
///
/// Example usage:
/// ```dart
/// // Enable logging to see warning and error messages
/// PsdLogging.enable();
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
  /// 1. Printed to the console with appropriate severity indicators
  /// 2. Stored in the error buffer for later retrieval via [popLastError]
  ///
  /// Note: Logging is disabled by default for performance reasons. Only enable
  /// logging when debugging or when detailed error information is needed.
  static void enable() {
    psdEnableLogging = true;
  }

  /// Disables logging for the PSD SDK.
  ///
  /// When disabled:
  /// - Warning and error messages will not be printed
  /// - The error buffer will not be updated
  /// - Performance will be optimized
  ///
  /// This is the default state of the SDK and should be used in production
  /// environments where logging is not needed.
  static void disable() {
    psdEnableLogging = false;
  }
}
