import 'dart:typed_data';

/// Base class for all files.
class File {
  Uint8List? get bytes => uint8list;
  ByteBuffer? get buffer => uint8list?.buffer;
  ByteData? get byteData => _byteData;

  int getSize() => uint8list?.length ?? 0;

  Uint8List? uint8list;
  ByteData? _byteData;

  File()
      : uint8list = null,
        _byteData = null;

  /// Creates a new [File] instance from [ByteData].
  ///
  /// This constructor initializes the file with the provided byte data,
  /// converting it to the appropriate internal representations.
  File.fromByteData(Uint8List data)
      : uint8list = data,
        _byteData = data.buffer.asByteData();

  void setByteData(Uint8List data) {
    uint8list = data;
    _byteData = data.buffer.asByteData();
  }
}
