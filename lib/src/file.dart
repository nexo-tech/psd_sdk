import 'dart:typed_data';

/// Base class for all files.
class File {
  Uint8List? get bytes => uint8list;
  ByteBuffer? get buffer => uint8list?.buffer;
  ByteData? get byteData => _byteData;

  void setByteData(Uint8List bytes) {
    uint8list = bytes;
    _byteData = uint8list?.buffer.asByteData();
  }

  int getSize() => uint8list?.length ?? 0;

  Uint8List? uint8list;
  ByteData? _byteData;

  File();
}
