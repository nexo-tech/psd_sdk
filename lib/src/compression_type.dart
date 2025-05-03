/// An enumeration representing the compression methods supported by Photoshop for PSD files.
///
/// This enum defines the various compression algorithms that can be used to compress
/// image data in Photoshop documents. Each compression type has different characteristics
/// in terms of compression ratio, speed, and compatibility.
///
/// The compression type is specified in the PSD file header and affects how the
/// image data is stored and read. Choosing the appropriate compression type can
/// significantly impact file size and performance.
///
/// Example usage:
/// ```dart
/// // Use raw (uncompressed) data
/// final rawCompression = CompressionType.raw;
/// print(rawCompression.value); // 0
///
/// // Use RLE compression
/// final rleCompression = CompressionType.rle;
/// print(rleCompression.value); // 1
///
/// // Use ZIP compression
/// final zipCompression = CompressionType.zip;
/// print(zipCompression.value); // 2
///
/// // Convert from a PSD compression identifier
/// final compression = CompressionType.fromValue(1);
/// print(compression); // CompressionType.rle
/// ```
enum CompressionType {
  /// Raw (uncompressed) data.
  ///
  /// This compression type indicates that the image data is stored without
  /// any compression. While this results in larger file sizes, it provides
  /// the fastest read and write performance.
  ///
  /// Use this type when:
  /// - Performance is more important than file size
  /// - Working with small images
  /// - Maximum compatibility is required
  raw(0),

  /// RLE (Run-Length Encoding) compressed data.
  ///
  /// This compression type uses the PackBits algorithm, which is a simple
  /// form of run-length encoding. It works well for images with large areas
  /// of uniform color.
  ///
  /// Characteristics:
  /// - Moderate compression ratio
  /// - Fast compression and decompression
  /// - Lossless compression
  /// - Good for images with repeating patterns
  rle(1),

  /// ZIP compressed data.
  ///
  /// This compression type uses the ZIP algorithm, which provides better
  /// compression ratios than RLE but may be slower to compress and decompress.
  ///
  /// Characteristics:
  /// - High compression ratio
  /// - Slower compression and decompression
  /// - Lossless compression
  /// - Good for complex images
  zip(2),

  /// ZIP compressed data with prediction (delta-encoding).
  ///
  /// This compression type combines ZIP compression with delta-encoding,
  /// which can provide even better compression ratios for certain types
  /// of images.
  ///
  /// Characteristics:
  /// - Very high compression ratio
  /// - Slowest compression and decompression
  /// - Lossless compression
  /// - Best for images with gradual color changes
  zipWithPrediction(3);

  /// Creates a new [CompressionType] instance with the specified value.
  ///
  /// The [value] parameter represents the compression type identifier in the
  /// PSD file format. This value is used when reading and writing the
  /// compression type in the file header.
  const CompressionType(this.value);

  /// The numeric value representing this compression type.
  ///
  /// This value serves as the compression type identifier in the PSD file format:
  /// - 0: Raw (uncompressed) data
  /// - 1: RLE compression
  /// - 2: ZIP compression
  /// - 3: ZIP compression with prediction
  ///
  /// The value is used when:
  /// - Reading the compression type from a PSD file
  /// - Writing the compression type to a PSD file
  /// - Determining how to decompress the image data
  final int value;

  /// Creates a [CompressionType] instance from a numeric value.
  ///
  /// This factory method converts a PSD compression type identifier into the
  /// corresponding [CompressionType] enum value.
  ///
  /// Parameters:
  /// - [value]: The numeric value representing the compression type
  ///
  /// Returns:
  /// The corresponding [CompressionType] enum value, or null if the value
  /// does not correspond to any supported compression type.
  ///
  /// Example:
  /// ```dart
  /// final compression = CompressionType.fromValue(2);
  /// print(compression); // CompressionType.zip
  ///
  /// final invalidCompression = CompressionType.fromValue(4);
  /// print(invalidCompression); // null
  /// ```
  static CompressionType? fromValue(int value) {
    try {
      return CompressionType.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}
