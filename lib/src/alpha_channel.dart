/// A class containing constants that define the different modes of an alpha channel.
///
/// These constants are used to specify how the alpha channel data should be
/// interpreted and processed. Each mode affects how the channel's data
/// contributes to the final image.
///
/// Example usage:
/// ```dart
/// final channel = AlphaChannel();
/// channel.mode = AlphaChannelMode.alpha; // Regular alpha channel
/// ```
class AlphaChannelMode {
  /// Indicates that the channel stores regular alpha data.
  ///
  /// In this mode, the channel data represents standard alpha values where:
  /// - Higher values indicate more opacity
  /// - Lower values indicate more transparency
  /// - The data is used directly for compositing
  static const alpha = 0;

  /// Indicates that the channel stores inverted alpha data.
  ///
  /// In this mode, the channel data represents inverted alpha values where:
  /// - Higher values indicate more transparency
  /// - Lower values indicate more opacity
  /// - The data must be inverted before use in compositing
  static const invertedAlpha = 1;

  /// Indicates that the channel stores spot color data.
  ///
  /// In this mode, the channel represents a spot color channel where:
  /// - The data is used for special printing effects
  /// - The color values are typically used for specific ink colors
  /// - The opacity controls the intensity of the spot color
  static const spot = 2;
}

/// A class representing an alpha channel in a Photoshop document.
///
/// This class encapsulates the properties and metadata of an alpha channel,
/// which is used to store transparency information in a Photoshop document.
/// Alpha channels can be used for various purposes, including:
///
/// - Storing transparency masks
/// - Creating selection masks
/// - Defining spot colors
/// - Storing custom channel data
///
/// Note that while this class stores the metadata for alpha channels, the
/// actual image data for alpha channels is stored in the image data section
/// of the PSD file.
///
/// Example usage:
/// ```dart
/// final channel = AlphaChannel();
/// channel.asciiName = "Transparency";
/// channel.mode = AlphaChannelMode.alpha;
/// channel.opacity = 100;
/// channel.color[0] = 0; // Red component
/// channel.color[1] = 0; // Green component
/// channel.color[2] = 0; // Blue component
/// channel.color[3] = 255; // Alpha component
/// ```
class AlphaChannel {
  /// Creates a new [AlphaChannel] instance.
  ///
  /// The constructor initializes the color array with four zeros, representing
  /// the RGBA components of the channel's color.
  AlphaChannel() : color = List<int>.filled(4, 0);

  /// The ASCII name of the alpha channel.
  ///
  /// This property stores the name of the channel as it appears in Photoshop.
  /// The name is limited to ASCII characters and is used for display purposes
  /// in the Photoshop interface.
  String? asciiName;

  /// The color space in which the channel's colors are stored.
  ///
  /// This value indicates the color space used for the channel's color data.
  /// It affects how the color values are interpreted when the channel is
  /// displayed or used in compositing operations.
  int? colorSpace;

  /// The color data for the alpha channel.
  ///
  /// This array contains four 16-bit color components in the following order:
  /// - Index 0: Red component (0-65535)
  /// - Index 1: Green component (0-65535)
  /// - Index 2: Blue component (0-65535)
  /// - Index 3: Alpha component (0-65535)
  ///
  /// The values are stored as 16-bit integers, where:
  /// - 0 represents black or fully transparent
  /// - 65535 represents white or fully opaque
  final List<int> color;

  /// The opacity of the alpha channel.
  ///
  /// This value represents the overall opacity of the channel, where:
  /// - 0 represents completely transparent
  /// - 100 represents completely opaque
  ///
  /// The opacity affects how the channel's data contributes to the final
  /// image when used in compositing operations.
  int? opacity;

  /// The mode of the alpha channel.
  ///
  /// This value determines how the channel's data should be interpreted and
  /// processed. It must be one of the constants defined in [AlphaChannelMode]:
  /// - [AlphaChannelMode.alpha]: Regular alpha data
  /// - [AlphaChannelMode.invertedAlpha]: Inverted alpha data
  /// - [AlphaChannelMode.spot]: Spot color data
  ///
  /// The mode affects how the channel's data is used in compositing and
  /// how it appears in the Photoshop interface.
  int? mode;
}
