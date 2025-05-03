/// A class holding compression types known by Photoshop.
enum CompressionType {
  /// Raw data.
  raw(0),

  /// RLE-compressed data (using the PackBits algorithm).
  rle(1),

  /// ZIP-compressed data.
  zip(2),

  /// ZIP-compressed data with prediction (delta-encoding).
  zipWithPrediction(3);

  const CompressionType(this.value);
  final int value;

  static CompressionType? fromValue(int value) {
    try {
      return CompressionType.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}
