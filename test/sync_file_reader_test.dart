import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:psd_sdk/src/sync_file_reader.dart'; // Adjust the import path as needed
import 'package:psd_sdk/src/file.dart';

// MockFile implements the interface needed by SyncFileReader
class MockFile implements File {
  MockFile(List<int> bytes) {
    setByteData(Uint8List.fromList(bytes));
  }

  MockFile.nullBoth() {
    uint8list = null;
  }

  @override
  Uint8List? uint8list;

  @override
  ByteBuffer? get buffer => uint8list?.buffer;

  @override
  ByteData? get byteData => uint8list?.buffer.asByteData();

  @override
  Uint8List? get bytes => uint8list;

  @override
  int getSize() => uint8list?.length ?? 0;

  @override
  void setByteData(Uint8List bytes) {
    uint8list = bytes;
  }
}

void main() {
  group('SyncFileReader normal behavior', () {
    late SyncFileReader reader;
    const List<int> bytes = [
      0xDE, 0xAD, 0xBE, 0xEF, // 0xDEADBEEF
      0x01, 0x02, // uint16: big=0x0102, little=0x0201
      0xFF, 0xFE, // int16: big=-2, little=-257
      0x00, 0x00, 0x00, 0x03, // int32: 3
      0x40, 0x09, 0x21, 0xFB, 0x54, 0x44, 0x2D, 0x18, // float64: π
      0xAA, 0xBB, 0xCC, 0xDD // extra bytes
    ];

    setUp(() {
      reader = SyncFileReader(MockFile(bytes));
    });

    test('initial position is 0', () {
      expect(reader.getPosition(), equals(0));
    });

    test('readUint32 big endian', () {
      expect(reader.readUint32(), equals(0xDEADBEEF));
    });

    test('readUint32 little endian', () {
      reader.setPosition(0);
      expect(reader.readUint32(Endian.little), equals(0xEFBEADDE));
    });

    test('readUint16 big endian', () {
      reader.setPosition(4);
      expect(reader.readUint16(), equals(0x0102));
    });

    test('readUint16 little endian', () {
      reader.setPosition(4);
      expect(reader.readUint16(Endian.little), equals(0x0201));
    });

    test('readInt16 big endian negative', () {
      reader.setPosition(6);
      expect(reader.readInt16(), equals(-2));
    });

    test('readInt16 little endian negative', () {
      reader.setPosition(6);
      expect(reader.readInt16(Endian.little), equals(-257));
    });

    test('readInt32 big endian', () {
      reader.setPosition(8);
      expect(reader.readInt32(), equals(3));
    });

    test('readFloat64 big endian', () {
      reader.setPosition(12);
      expect(reader.readFloat64(), closeTo(3.141592653589793, 1e-12));
    });

    test('readByte', () {
      reader.setPosition(20);
      expect(reader.readByte(), equals(0xAA));
    });

    test('readBytes returns correct sublist', () {
      reader.setPosition(20);
      final bytesRead = reader.readBytes(4);
      expect(bytesRead, equals([0xAA, 0xBB, 0xCC, 0xDD]));
    });

    test('skip advances position', () {
      reader.skip(10);
      expect(reader.getPosition(), equals(10));
    });

    test('chained operations', () {
      final u32 = reader.readUint32(); // pos=4
      final u16 = reader.readUint16(); // pos=6
      reader.skip(2); // pos=8
      final i32 = reader.readInt32(); // pos=12
      expect(u32, equals(0xDEADBEEF));
      expect(u16, equals(0x0102));
      expect(i32, equals(3));
      expect(reader.getPosition(), equals(12));
    });
  });

  group('SyncFileReader null byteData or buffer', () {
    late SyncFileReader reader;
    setUp(() {
      reader = SyncFileReader(MockFile.nullBoth());
    });

    test('readUint32 returns 0 when byteData is null', () {
      expect(reader.readUint32(), equals(0));
    });

    test('readBytes returns null when buffer is null', () {
      expect(reader.readBytes(5), isNull);
    });

    test('reading beyond data returns default or null gracefully', () {
      expect(reader.readInt16(), equals(0));
      expect(reader.readInt32(), equals(0));
      expect(reader.readFloat64(), equals(0));
    });
  });
}
