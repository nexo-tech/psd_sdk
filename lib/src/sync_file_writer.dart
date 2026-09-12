import 'dart:typed_data';

import 'file.dart';

/// Accumulates the bytes of a document being exported and hands them to a
/// [File] on [save].
///
/// Bytes are collected in a [BytesBuilder] instead of a growable `List<int>`.
/// A `List<int>` stores every byte as a full machine word, so exporting a
/// document briefly needed roughly 8-16x the size of the resulting PSD (plus
/// one more copy in [save]). With a [BytesBuilder] the peak is about twice the
/// PSD size: the collected chunks plus the single contiguous result produced
/// by [BytesBuilder.takeBytes]. The bytes written are exactly the same.
class SyncFileWriter {
  SyncFileWriter(File file) : _file = file;

  /// Writes [count] bytes from [buffer] (the whole buffer when [count] is
  /// omitted), incrementing the internal write position.
  ///
  /// Accepts a [ByteBuffer], a [Uint8List], a [String] (one byte per code
  /// unit, zero padded up to [count]) or a [ByteData] together with [count].
  void write<T>(T buffer, [int? count]) {
    final Uint8List chunk;
    if (buffer is ByteBuffer) {
      count ??= buffer.lengthInBytes;
      chunk = Uint8List.fromList(buffer.asUint8List(0, count));
    } else if (buffer is ByteData && count != null) {
      chunk = Uint8List(count);
      for (var x = 0; x < count; x++) {
        chunk[x] = buffer.getUint8(x);
      }
    } else if (buffer is Uint8List) {
      count ??= buffer.length;
      chunk = buffer.sublist(0, count);
    } else if (buffer is String) {
      count ??= buffer.length;
      chunk = Uint8List(count);
      for (var x = 0; x < count; x++) {
        chunk[x] = x >= buffer.length ? 0 : buffer.codeUnitAt(x);
      }
    } else {
      throw Error();
    }
    // Every chunk above is a fresh copy, so the builder can keep a reference
    // to it without copying again.
    _builder.add(chunk);
    _position += chunk.length;
  }

  /// Returns the internal write position.
  int getPosition() => _position;

  /// Stores everything written so far in the [File] as one contiguous
  /// [Uint8List] and releases the collected chunks.
  void save() {
    _file.setByteData(_builder.takeBytes());
  }

  final BytesBuilder _builder = BytesBuilder(copy: false);
  int _position = 0;
  final File _file;
}
