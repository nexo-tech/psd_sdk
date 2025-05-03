import 'dart:io' as io;
import 'dart:typed_data';

abstract class NumDataType {}

class U8 extends NumDataType {}

class U16 extends NumDataType {}

int sizeof<T extends NumDataType>() {
  switch (T) {
    case U16:
      return 2;
    case U8:
      return 1;
    default:
      throw Error();
  }
}

void setByteData<T extends NumDataType>(ByteData data, num value,
    [Endian? endian]) {
  endian ??= Endian.host;
  switch (T) {
    case U16:
      data.setUint16(0, value.toInt(), endian);
      break;
    case U8:
      data.setUint8(0, value.toInt());
      break;
    default:
      throw Error();
  }
}

class TgaType {
  // TGA file contains BGR triplets of color data.
  static const bgrUncompressed = 2;

  // TGA file contains grayscale values.
  static const monoUncompressed = 3;
}

class TgaHeader {
  /* uint8_t */
  int? idLength;
  /* uint8_t */
  int? paletteType;
  /* uint8_t */
  int? type;
  /* uint16_t */
  int? paletteOffset;
  /* uint16_t */
  int? paletteLength;
  /* uint8_t */
  int? bitsPerPaletteEntry;
  /* uint16_t */
  int? originX;
  /* uint16_t */
  int? originY;
  /* uint16_t */
  int? width;
  /* uint16_t */
  int? height;
  /* uint8_t */
  int? bitsPerPixel;
  /* uint8_t */
  int? attributes;
}

TgaHeader createHeader(int width, int height, int type, int bitsPerPixel) {
  var header = TgaHeader();
  header.idLength = 0;
  header.paletteType = 0;
  header.type = type;
  header.paletteOffset = 0;
  header.paletteLength = 0;
  header.bitsPerPaletteEntry = 0;
  header.originX = 0;
  header.originY = 0;
  header.width = width;
  header.height = height;
  header.bitsPerPixel = bitsPerPixel;
  header.attributes = 0x20;
  return header;
}

class TgaFile {
  String filename;
  late io.File _file;

  TgaFile(this.filename) {
    _file = io.File(filename);
  }

  void write<T extends NumDataType>(num value) {
    var length = sizeof<T>();
    var bd = ByteData(length);
    setByteData<T>(bd, value);

    for (var x = 0; x < length; x++) {
      list.add(bd.getUint8(x));
    }
  }

  void writeHeader(TgaHeader header) {
    write<U8>(header.idLength ?? 0);
    write<U8>(header.paletteType ?? 0);
    write<U8>(header.type ?? 0);
    write<U16>(header.paletteOffset ?? 0);
    write<U16>(header.paletteLength ?? 0);
    write<U8>(header.bitsPerPaletteEntry ?? 0);
    write<U16>(header.originX ?? 0);
    write<U16>(header.originY ?? 0);
    write<U16>(header.width ?? 0);
    write<U16>(header.height ?? 0);
    write<U8>(header.bitsPerPixel ?? 0);
    write<U8>(header.attributes ?? 0);
  }

  var list = <int>[];

  void writeBytes(Uint8List bytes) {
    list.addAll(bytes);
    _bytes = Uint8List.fromList(list);
  }

  bool close() {
    if (_bytes == null) {
      return false;
    }
    try {
      _file.writeAsBytesSync(_bytes!);
      return true;
    } catch (e) {
      return false;
    }
  }

  Uint8List? _bytes;
}

TgaFile createFile(String filename) {
  return TgaFile(filename);
}

void saveMonochrome(String filename, int width, int height, Uint8List data) {
  var file = createFile(filename);

  var header = createHeader(width, height, TgaType.monoUncompressed, 8);
  file.writeHeader(header);
  file.writeBytes(data);
  if (!file.close()) {
    print("Couldn't write the file");
  }
}

void saveRGB(String filename, int width, int height, Uint8List data) {
  var file = createFile(filename);

  var header = createHeader(width, height, TgaType.bgrUncompressed, 24);
  file.writeHeader(header);

  final colors = Uint8List(width * height * 3);
  for (var i = 0; i < height; ++i) {
    for (var j = 0; j < width; ++j) {
      final r = data[(i * width + j) * 4 + 0];
      final g = data[(i * width + j) * 4 + 1];
      final b = data[(i * width + j) * 4 + 2];

      colors[(i * width + j) * 3 + 2] = r;
      colors[(i * width + j) * 3 + 1] = g;
      colors[(i * width + j) * 3 + 0] = b;
    }
  }

  file.writeBytes(colors);
  if (!file.close()) {
    print("Couldn't write the file");
  }
}

void saveRGBA(String filename, int width, int height, Uint8List data) {
  var file = createFile(filename);

  var header = createHeader(width, height, TgaType.bgrUncompressed, 32);
  file.writeHeader(header);

  final colors = Uint8List(width * height * 4);
  for (var i = 0; i < height; ++i) {
    for (var j = 0; j < width; ++j) {
      final r = data[(i * width + j) * 4 + 0];
      final g = data[(i * width + j) * 4 + 1];
      final b = data[(i * width + j) * 4 + 2];
      final a = data[(i * width + j) * 4 + 3];

      colors[(i * width + j) * 4 + 2] = r;
      colors[(i * width + j) * 4 + 1] = g;
      colors[(i * width + j) * 4 + 0] = b;
      colors[(i * width + j) * 4 + 3] = a;
    }
  }
  file.writeBytes(colors);
  if (!file.close()) {
    print("Couldn't write the file");
  }
}
