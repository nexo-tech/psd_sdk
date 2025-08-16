import 'dart:io';
import 'package:test/test.dart';

void main() {
  group('Code Quality Tests', () {
    test('library should not contain print statements', () {
      // Find all Dart files in the lib directory
      final libDir = Directory('lib');
      final dartFiles = libDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))
          .toList();

      expect(dartFiles, isNotEmpty,
          reason: 'Should find Dart files in lib directory');

      final filesWithPrint = <String>[];

      for (final file in dartFiles) {
        final content = file.readAsStringSync();
        final lines = content.split('\n');

        for (var i = 0; i < lines.length; i++) {
          final line = lines[i];

          // Skip commented lines and documentation examples
          if (line.trim().startsWith('//') || line.trim().startsWith('///')) {
            continue;
          }

          // Check for print statements (but allow in documentation examples)
          if (line.contains('print(') && !line.contains('/// ')) {
            filesWithPrint.add('${file.path}:${i + 1}: ${line.trim()}');
          }
        }
      }

      if (filesWithPrint.isNotEmpty) {
        fail(
            'Found print statements in library code:\n${filesWithPrint.join('\n')}');
      }
    });

    test('library should use proper logging instead of print', () {
      // Verify that psdWarning and psdError functions exist and are used
      final parseLayerMaskFile = File('lib/src/parse_layer_mask_section.dart');
      final exportDocumentFile = File('lib/src/export_document.dart');

      expect(parseLayerMaskFile.existsSync(), isTrue);
      expect(exportDocumentFile.existsSync(), isTrue);

      final parseContent = parseLayerMaskFile.readAsStringSync();
      final exportContent = exportDocumentFile.readAsStringSync();

      // Verify proper logging functions are used
      expect(parseContent, contains('psdError('),
          reason:
              'parse_layer_mask_section.dart should use psdError for error logging');
      expect(exportContent, contains('psdWarning('),
          reason:
              'export_document.dart should use psdWarning for warning logging');
    });
  });
}
