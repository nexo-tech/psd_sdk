import 'dart:typed_data';

import 'package:psd_sdk/psd_sdk.dart';
import 'package:psd_sdk/src/sync_file_writer.dart';
import 'package:test/test.dart';

/// Reference accumulation with the semantics of the previous implementation
/// (a growable `List<int>` that every write() appended to). Kept here so the
/// writer can change its storage strategy without changing its output.
List<int> _legacyBytes(void Function(SyncFileWriter w) script) {
  final file = File();
  final writer = SyncFileWriter(file);
  script(writer);
  writer.save();
  return file.bytes!;
}

Uint8List _plane(int n, int Function(int) f) {
  final p = Uint8List(n);
  for (var i = 0; i < n; i++) {
    p[i] = f(i);
  }
  return p;
}

/// FNV-1a 64-bit, used to pin the exact bytes produced by writeDocument.
int _fnv1a(Uint8List bytes) {
  var h = 0xcbf29ce484222325;
  for (final b in bytes) {
    h ^= b;
    h = (h * 0x100000001b3) & 0xFFFFFFFFFFFFFFFF;
  }
  return h;
}

Uint8List _buildDocument(CompressionType compression, {bool meta = false}) {
  const w = 37, h = 11, n = w * h;
  final doc = ExportDocument(w, h, 8, ExportColorMode.rgb);
  if (meta) doc.addMetaData('Author', 'psd_sdk test');
  for (var l = 0; l < 3; l++) {
    final layer = doc.addLayer(doc, 'Layer $l')!;
    doc.updateLayer(layer, ExportChannel.red, 0, 0, w, h,
        _plane(n, (i) => (i + l * 7) & 0xff), compression);
    doc.updateLayer(layer, ExportChannel.green, 0, 0, w, h,
        _plane(n, (i) => (i * 3 + l) & 0xff), compression);
    doc.updateLayer(layer, ExportChannel.blue, 0, 0, w, h,
        _plane(n, (i) => l * 40), compression);
    doc.updateLayer(layer, ExportChannel.alpha, 0, 0, w, h,
        _plane(n, (i) => i % w < 20 ? 255 : 0), compression);
  }
  doc.updateMergedImage(_plane(n, (i) => i & 0xff), _plane(n, (i) => 128),
      _plane(n, (i) => 255 - (i & 0xff)));
  final file = File();
  doc.write(file);
  return file.bytes!;
}

void main() {
  group('SyncFileWriter.write', () {
    test('Uint8List: whole buffer, or the first count bytes', () {
      final data = Uint8List.fromList([1, 2, 3, 4, 5]);
      expect(_legacyBytes((w) => w.write(data)), [1, 2, 3, 4, 5]);
      expect(_legacyBytes((w) => w.write(data, 3)), [1, 2, 3]);
    });

    test('ByteBuffer: whole buffer, or the first count bytes', () {
      final buffer = Uint8List.fromList([9, 8, 7, 6]).buffer;
      expect(_legacyBytes((w) => w.write(buffer)), [9, 8, 7, 6]);
      expect(_legacyBytes((w) => w.write(buffer, 2)), [9, 8]);
    });

    test('ByteData with count: bytes in stored order', () {
      final bd = ByteData(4)..setUint32(0, 0x01020304, Endian.big);
      expect(_legacyBytes((w) => w.write(bd, 4)), [1, 2, 3, 4]);
      expect(_legacyBytes((w) => w.write(bd, 2)), [1, 2]);
    });

    test('String: code units, zero-padded up to count', () {
      expect(_legacyBytes((w) => w.write('AB')), [0x41, 0x42]);
      expect(_legacyBytes((w) => w.write('AB', 5)), [0x41, 0x42, 0, 0, 0]);
      expect(_legacyBytes((w) => w.write('ABC', 2)), [0x41, 0x42]);
    });

    test('unsupported types throw, as before', () {
      expect(() => _legacyBytes((w) => w.write(42)), throwsA(isA<Error>()));
      expect(() => _legacyBytes((w) => w.write(ByteData(2))),
          throwsA(isA<Error>()));
    });

    test('getPosition() is the number of bytes written so far', () {
      final writer = SyncFileWriter(File());
      expect(writer.getPosition(), 0);
      writer.write(Uint8List(7));
      expect(writer.getPosition(), 7);
      writer.write('xyz', 8);
      expect(writer.getPosition(), 15);
      writer.write(ByteData(4), 2);
      expect(writer.getPosition(), 17);
    });

    test('written buffers are copied (later mutation does not leak)', () {
      final data = Uint8List.fromList([1, 2, 3]);
      final file = File();
      final writer = SyncFileWriter(file);
      writer.write(data);
      data[0] = 99;
      writer.save();
      expect(file.bytes, [1, 2, 3]);
    });

    test('save() sets bytes with offsetInBytes 0 and exact length', () {
      final file = File();
      final writer = SyncFileWriter(file)
        ..write(Uint8List.fromList([1, 2]))
        ..write('Z', 3);
      writer.save();
      expect(file.bytes!.offsetInBytes, 0);
      expect(file.bytes!.length, 5);
      expect(file.getSize(), 5);
      expect(file.byteData!.lengthInBytes, 5);
    });
  });

  group('writeDocument output is unchanged (golden from the List<int> writer)',
      () {
    // Lengths and FNV-1a hashes were produced by psd_sdk 0.2.3 (List<int>
    // based SyncFileWriter) for exactly these documents. A change here means
    // the bytes written to disk changed, which this refactor must not do.
    test('RLE layers', () {
      final bytes = _buildDocument(CompressionType.rle);
      expect(bytes.length, 4489);
      expect(_fnv1a(bytes), 7031351022534670104);
    });

    test('RAW layers', () {
      final bytes = _buildDocument(CompressionType.raw);
      expect(bytes.length, 6401);
      expect(_fnv1a(bytes), -7521409644970717668);
    });

    test('RLE layers with XMP metadata (exercises the String path)', () {
      final bytes = _buildDocument(CompressionType.rle, meta: true);
      expect(bytes.length, 4997);
      expect(_fnv1a(bytes), 3035715941481836435);
    });
  });
}
