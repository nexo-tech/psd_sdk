import 'dart:io' as io;
import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:psd_sdk/psd_sdk.dart';
import 'package:psd_sdk/src/section.dart';

void main() {
  group('Unicode Layer Name Tests', () {
    test('should parse PSD with Japanese layer names correctly', () {
      // This test ensures that PSD files with Unicode characters (especially Japanese)
      // in layer names are parsed correctly without null layers

      final testFile = io.File('example/test_unicode.psd');
      if (!testFile.existsSync()) {
        fail(
            'Test file not found: example/test_unicode.psd. Please ensure the test file exists.');
      }

      final file = File();
      file.setByteData(testFile.readAsBytesSync());

      final document = Document.fromFile(file);
      expect(document, isNotNull);
      expect(document.colorMode, equals(ColorMode.rgb));

      final layerMaskSection = document.parseLayerMaskSection(file);
      expect(layerMaskSection, isNotNull);
      expect(layerMaskSection!.layerCount, equals(9));

      // Expected layer names
      final expectedNames = [
        '用紙',
        'Layer1',
        'Layer1 のコピー',
        'Layer2',
        'Layer2 のコピー',
        'Layer3',
        'Layer3 のコピー',
        'Layer4',
        'Layer4 のコピー',
      ];

      // Check all layers are parsed (not null)
      int nonNullCount = 0;
      for (int i = 0; i < layerMaskSection.layerCount; i++) {
        final layer = layerMaskSection.layers![i];
        expect(layer, isNotNull, reason: 'Layer $i should not be null');

        if (layer != null) {
          nonNullCount++;
          expect(layer.name, equals(expectedNames[i]),
              reason: 'Layer $i name mismatch');

          // Verify layer can be extracted without errors
          expect(() => layer.extract(file), returnsNormally,
              reason: 'Layer $i should extract without errors');
        }
      }

      expect(nonNullCount, equals(9),
          reason: 'All 9 layers should be successfully parsed');
    });

    test('should handle null check errors gracefully', () {
      // This test verifies that the null check issue is fixed
      // by ensuring layers with null values are skipped in hierarchy building

      final file = File();
      file.setByteData(Uint8List(1000)); // Dummy data

      // The parseLayerMaskSection should not throw null check errors
      // even with malformed data
      final document = Document();
      document.layerMaskInfoSection = Section()
        ..offset = 0
        ..length = 100;

      // This should not throw, even if parsing fails
      expect(() {
        document.parseLayerMaskSection(file);
        // Result might be null or have null layers, but shouldn't crash
      }, returnsNormally);
    });
  });
}
