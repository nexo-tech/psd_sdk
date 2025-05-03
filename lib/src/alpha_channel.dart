class AlphaChannelMode {
  /// The channel stores alpha data.
  static const alpha = 0;

  /// The channel stores inverted alpha data.
  static const invertedAlpha = 1;

  /// The channel stores spot color data.
  static const spot = 2;
}

/// A struct representing an alpha channel as stored in the image resources section.
///
/// Note that the image data for alpha channels is stored in the image data section.
class AlphaChannel {
  AlphaChannel() : color = List<int>.filled(4, 0);

  /// The channel's ASCII name.
  String? asciiName;

  /// The color space the colors are stored in.
  int? colorSpace;

  /// 16-bit color data with 0 being black and 65535 being white (assuming RGBA).
  final List<int> color;

  /// The channel's opacity in the range [0, 100].
  int? opacity;

  /// The channel's mode, one of AlphaChannel::Mode.
  int? mode;
}
