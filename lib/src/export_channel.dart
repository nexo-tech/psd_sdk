/// An enumeration representing the channels that can be exported to a PSD document's Layer Mask section.
///
/// This enum defines the supported channel types that can be exported to a Photoshop
/// document's Layer Mask section. Each value represents a specific color channel or
/// alpha channel, with a corresponding numeric identifier used in the PSD file format.
///
/// The enum values are used to specify which channels should be included when
/// exporting layer data, allowing for precise control over the exported document's
/// channel structure.
///
/// Example usage:
/// ```dart
/// // Export a grayscale channel
/// final grayChannel = ExportChannel.gray;
/// print(grayChannel.value); // 0
///
/// // Export RGB channels
/// final redChannel = ExportChannel.red;
/// final greenChannel = ExportChannel.green;
/// final blueChannel = ExportChannel.blue;
///
/// // Export an alpha channel
/// final alphaChannel = ExportChannel.alpha;
/// print(alphaChannel.value); // 4
///
/// // Convert from a PSD channel identifier
/// final channel = ExportChannel.fromValue(2);
/// print(channel); // ExportChannel.green
/// ```
enum ExportChannel {
  /// The grayscale channel.
  ///
  /// This channel represents the intensity values in a grayscale image.
  /// It is used when exporting monochromatic data and has a value of 0,
  /// indicating it is the primary channel in grayscale mode.
  gray(0),

  /// The red color channel.
  ///
  /// This channel contains the red component of an RGB image.
  /// It has a value of 1, indicating it is the first color channel
  /// in RGB mode.
  red(1),

  /// The green color channel.
  ///
  /// This channel contains the green component of an RGB image.
  /// It has a value of 2, indicating it is the second color channel
  /// in RGB mode.
  green(2),

  /// The blue color channel.
  ///
  /// This channel contains the blue component of an RGB image.
  /// It has a value of 3, indicating it is the third color channel
  /// in RGB mode.
  blue(3),

  /// The alpha channel.
  ///
  /// This channel contains transparency information for the image.
  /// It has a value of 4, indicating it is the alpha channel in
  /// both grayscale and RGB modes.
  alpha(4);

  /// Creates a new [ExportChannel] instance with the specified value.
  ///
  /// The [value] parameter represents the channel's identifier in the
  /// PSD file format. This value is used when writing channel data
  /// to the Layer Mask section.
  const ExportChannel(this.value);

  /// The numeric value representing this channel type.
  ///
  /// This value serves as the channel identifier in the PSD file format:
  /// - 0: Grayscale channel
  /// - 1: Red channel
  /// - 2: Green channel
  /// - 3: Blue channel
  /// - 4: Alpha channel
  ///
  /// The value is used when:
  /// - Writing channel data to the PSD file
  /// - Identifying channels in the Layer Mask section
  /// - Specifying channel order in the exported document
  final int value;

  /// Creates an [ExportChannel] instance from a numeric value.
  ///
  /// This factory method converts a PSD channel identifier into the
  /// corresponding [ExportChannel] enum value.
  ///
  /// Parameters:
  /// - [value]: The numeric value representing the channel type
  ///
  /// Returns:
  /// The corresponding [ExportChannel] enum value, or null if the value
  /// does not correspond to any supported channel type.
  ///
  /// Example:
  /// ```dart
  /// final channel = ExportChannel.fromValue(1);
  /// print(channel); // ExportChannel.red
  ///
  /// final invalidChannel = ExportChannel.fromValue(5);
  /// print(invalidChannel); // null
  /// ```
  static ExportChannel? fromValue(int value) {
    try {
      return ExportChannel.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}
