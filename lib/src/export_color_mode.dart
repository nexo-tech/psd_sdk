/// An enumeration representing the color modes supported for exporting PSD documents.
///
/// This enum defines the supported color modes when exporting a Photoshop document,
/// mapping each mode to its corresponding number of channels and PSD mode identifier.
/// The enum values represent both the visual color mode and the technical channel
/// configuration required for the export.
///
/// Example usage:
/// ```dart
/// // Create a grayscale export configuration
/// final grayscaleMode = ExportColorMode.grayscale;
/// print(grayscaleMode.value); // 1
///
/// // Create an RGB export configuration
/// final rgbMode = ExportColorMode.rgb;
/// print(rgbMode.value); // 3
///
/// // Convert from a PSD mode identifier
/// final mode = ExportColorMode.fromValue(3);
/// print(mode); // ExportColorMode.rgb
/// ```
enum ExportColorMode {
  /// Grayscale color mode with a single channel.
  ///
  /// This mode represents a monochromatic image where each pixel is represented
  /// by a single channel containing intensity values. The value 1 indicates
  /// that the exported document will have one channel per pixel.
  grayscale(1),

  /// RGB color mode with three channels (red, green, blue).
  ///
  /// This mode represents a full-color image where each pixel is represented
  /// by three channels: red, green, and blue. The value 3 indicates that the
  /// exported document will have three channels per pixel.
  rgb(3);

  /// Creates a new [ExportColorMode] instance with the specified value.
  ///
  /// The [value] parameter represents both the number of channels in the
  /// exported document and the corresponding PSD mode identifier.
  const ExportColorMode(this.value);

  /// The numeric value representing this color mode.
  ///
  /// This value serves two purposes:
  /// 1. Indicates the number of channels in the exported document
  /// 2. Corresponds to the PSD mode identifier used in the file format
  ///
  /// For example:
  /// - [grayscale] has a value of 1 (single channel)
  /// - [rgb] has a value of 3 (three channels)
  final int value;

  /// Creates an [ExportColorMode] instance from a numeric value.
  ///
  /// This factory method converts a PSD mode identifier or channel count
  /// into the corresponding [ExportColorMode] enum value.
  ///
  /// Parameters:
  /// - [value]: The numeric value representing the color mode
  ///
  /// Returns:
  /// The corresponding [ExportColorMode] enum value, or null if the value
  /// does not correspond to any supported color mode.
  ///
  /// Example:
  /// ```dart
  /// final mode = ExportColorMode.fromValue(3);
  /// print(mode); // ExportColorMode.rgb
  ///
  /// final invalidMode = ExportColorMode.fromValue(4);
  /// print(invalidMode); // null
  /// ```
  static ExportColorMode? fromValue(int value) {
    try {
      return ExportColorMode.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}
