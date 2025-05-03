/// An enumeration representing the different types of channels in a Photoshop document.
///
/// This enum defines the various types of channels that can exist in a Photoshop
/// document, including color channels (R, G, B), transparency masks, and layer masks.
/// Each type represents a different kind of data that can be stored in a channel,
/// affecting how the channel is processed and displayed.
///
/// The enum values correspond to the internal type identifiers used in the
/// PSD file format, making it easier to work with channel type information
/// when reading or writing PSD files.
///
/// Example usage:
/// ```dart
/// // Find a specific channel in a layer
/// final redChannel = layer.findChannel(ChannelType.r);
///
/// // Check channel type
/// if (channel.type == ChannelType.transparencyMask) {
///   print('This is a transparency mask channel');
/// }
///
/// // Convert from PSD value
/// final type = ChannelType.fromValue(0); // Returns ChannelType.r
/// ```
enum ChannelType {
  /// Represents an invalid or uninitialized channel.
  ///
  /// This value is used internally to indicate that a channel no longer
  /// contains valid data. It should not be used in normal channel operations
  /// and is primarily for internal state management.
  invalid(32767),

  /// Represents the red color channel.
  ///
  /// This type denotes a channel containing red color information.
  /// Note that in RGB Color Mode documents, this channel might not always
  /// be the first channel, as channel order can vary.
  r(0),

  /// Represents the green color channel.
  ///
  /// This type denotes a channel containing green color information.
  /// Note that in RGB Color Mode documents, this channel might not always
  /// be the second channel, as channel order can vary.
  g(1),

  /// Represents the blue color channel.
  ///
  /// This type denotes a channel containing blue color information.
  /// Note that in RGB Color Mode documents, this channel might not always
  /// be the third channel, as channel order can vary.
  b(2),

  /// Represents a transparency mask channel.
  ///
  /// This type indicates that the channel contains transparency information
  /// for the layer. Transparency masks control which parts of the layer
  /// are visible or transparent.
  transparencyMask(-1),

  /// Represents either a layer mask or vector mask channel.
  ///
  /// This type is used when the channel could contain either a layer mask
  /// or a vector mask. Additional information is typically needed to
  /// determine the exact type of mask.
  layerOrVectorMask(-2),

  /// Represents a layer mask channel.
  ///
  /// This type indicates that the channel contains a layer mask, which
  /// is used to control the visibility of different parts of the layer
  /// through grayscale values.
  layerMask(-3);

  /// Creates a new [ChannelType] instance with the specified [value].
  ///
  /// The [value] parameter corresponds to the internal type identifier
  /// used in the PSD file format.
  const ChannelType(this.value);

  /// The integer value associated with this channel type in the PSD file format.
  ///
  /// This value is used when reading from or writing to PSD files to
  /// identify the type of channel being processed.
  final int value;

  /// Creates a [ChannelType] instance from its integer value.
  ///
  /// This factory method converts a PSD file's channel type value into
  /// the corresponding [ChannelType] enum value.
  ///
  /// Parameters:
  /// - [value]: The integer value from the PSD file
  ///
  /// Returns the corresponding [ChannelType] if the [value] matches one of
  /// the defined channel types, or `null` if no matching channel type is found.
  ///
  /// Example:
  /// ```dart
  /// final type = ChannelType.fromValue(0); // Returns ChannelType.r
  /// final invalid = ChannelType.fromValue(999); // Returns null
  /// ```
  static ChannelType? fromValue(int value) {
    try {
      return ChannelType.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}
