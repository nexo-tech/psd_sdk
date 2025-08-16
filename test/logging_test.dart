import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:psd_sdk/psd_sdk.dart';

void main() {
  group('Logging Tests', () {
    tearDown(() {
      // Disable logging after each test
      PsdLogging.disable();
      PsdLogging.setLogHandler(null);
    });

    test('should be disabled by default', () {
      // Logging should be disabled by default
      final messages = <String>[];
      PsdLogging.setLogHandler((level, channel, message) {
        messages.add('$level:$channel:$message');
      });

      // Create an invalid scenario that would trigger a warning if logging was enabled
      final document = ExportDocument(100, 100, 8, ExportColorMode.rgb);
      final layer = document.addLayer(document, 'test');

      // This should trigger a warning about unsupported data type, but won't because logging is disabled
      document.updateLayer(layer!, ExportChannel.red, 0, 0, 100, 100,
          Int32List(100 * 100), CompressionType.raw);

      expect(messages, isEmpty,
          reason: 'No messages should be logged when logging is disabled');
    });

    test('should capture messages when enabled with custom handler', () {
      final messages = <String>[];

      // Enable logging and set custom handler
      PsdLogging.enable();
      PsdLogging.setLogHandler((level, channel, message) {
        messages.add('$level:$channel:$message');
      });

      // Create an invalid scenario that should trigger a warning
      final document = ExportDocument(100, 100, 8, ExportColorMode.rgb);
      final layer = document.addLayer(document, 'test');

      // This should trigger a warning about unsupported data type
      document.updateLayer(layer!, ExportChannel.red, 0, 0, 100, 100,
          Int32List(100 * 100), CompressionType.raw);

      expect(messages, isNotEmpty,
          reason: 'Messages should be logged when logging is enabled');
      expect(messages.first,
          contains('WARNING:ExportDocument:Unsupported data type'));
      expect(messages.first, contains('Int32List'));
    });

    test('should capture error messages in error buffer', () {
      PsdLogging.enable();

      // Create an invalid scenario that would trigger an error
      final document = ExportDocument(100, 100, 8, ExportColorMode.rgb);
      final layer = document.addLayer(document, 'test');

      // This should trigger a warning and store it in error buffer
      document.updateLayer(layer!, ExportChannel.red, 0, 0, 100, 100,
          Int32List(100 * 100), CompressionType.raw);

      final lastError = PsdLogging.getLastError();
      expect(lastError, contains('Unsupported data type'));
    });

    test('should allow removing custom handler', () {
      final messages = <String>[];

      PsdLogging.enable();
      PsdLogging.setLogHandler((level, channel, message) {
        messages.add('$level:$channel:$message');
      });

      // Remove handler
      PsdLogging.setLogHandler(null);

      // Create an invalid scenario
      final document = ExportDocument(100, 100, 8, ExportColorMode.rgb);
      final layer = document.addLayer(document, 'test');
      document.updateLayer(layer!, ExportChannel.red, 0, 0, 100, 100,
          Int32List(100 * 100), CompressionType.raw);

      expect(messages, isEmpty,
          reason: 'No messages should be captured after removing handler');
    });

    test('should properly enable and disable logging', () {
      final messages = <String>[];
      PsdLogging.setLogHandler((level, channel, message) {
        messages.add('$level:$channel:$message');
      });

      // Start disabled
      expect(messages, isEmpty);

      // Enable
      PsdLogging.enable();
      final document = ExportDocument(100, 100, 8, ExportColorMode.rgb);
      final layer = document.addLayer(document, 'test');
      document.updateLayer(layer!, ExportChannel.red, 0, 0, 100, 100,
          Int32List(100 * 100), CompressionType.raw);

      expect(messages, isNotEmpty);
      messages.clear();

      // Disable
      PsdLogging.disable();
      document.updateLayer(layer, ExportChannel.green, 0, 0, 100, 100,
          Int32List(100 * 100), CompressionType.raw);

      expect(messages, isEmpty,
          reason: 'No messages should be logged after disabling');
    });
  });
}
