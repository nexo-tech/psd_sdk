/// An enumeration representing the color modes supported by Adobe Photoshop.
///
/// This enum provides a type-safe way to work with Photoshop's color modes,
/// mapping each mode to its corresponding integer value as used in the PSD file format.
///
/// Each color mode represents a different way of storing and representing color
/// information in an image:
///
/// - [bitmap]: Black and white only, 1 bit per pixel
/// - [grayscale]: Shades of gray, typically 8 or 16 bits per pixel
/// - [indexed]: Uses a color palette, typically 8 bits per pixel
/// - [rgb]: Red, Green, Blue color space, typically 24 or 48 bits per pixel
/// - [cmyk]: Cyan, Magenta, Yellow, Key (black) color space for printing
/// - [multichannel]: Multiple channels without color space information
/// - [duotone]: Special grayscale mode with additional spot colors
/// - [lab]: Lightness, a, b color space for device-independent color
///
/// Example usage:
/// ```dart
/// // Create a color mode from its value
/// final mode = ColorMode.fromValue(3);
/// print(mode); // ColorMode.rgb
///
/// // Get the integer value of a color mode
/// print(ColorMode.cmyk.value); // 4
/// ```
enum ColorMode {
  /// Bitmap color mode (1-bit per pixel).
  ///
  /// This mode represents images in pure black and white, with no intermediate
  /// shades. Each pixel is either fully black or fully white.
  bitmap(0),

  /// Grayscale color mode.
  ///
  /// Represents images using shades of gray, typically with 8 or 16 bits per
  /// pixel. This mode is commonly used for black and white photographs.
  grayscale(1),

  /// Indexed color mode.
  ///
  /// Uses a color palette (up to 256 colors) to represent the image. Each pixel
  /// is an index into the palette rather than a direct color value.
  indexed(2),

  /// RGB color mode.
  ///
  /// Represents colors using the Red, Green, Blue color space. This is the most
  /// common color mode for digital images and displays.
  rgb(3),

  /// CMYK color mode.
  ///
  /// Represents colors using the Cyan, Magenta, Yellow, and Key (black) color
  /// space. This mode is primarily used for print production.
  cmyk(4),

  /// Multichannel color mode.
  ///
  /// Contains multiple channels without any specific color space information.
  /// Often used for specialized printing processes.
  multichannel(7),

  /// Duotone color mode.
  ///
  /// A specialized grayscale mode that uses one to four custom inks to create
  /// enhanced grayscale images.
  duotone(8),

  /// LAB color mode.
  ///
  /// Represents colors using the Lightness, a, b color space, which is
  /// device-independent and designed to approximate human vision.
  lab(9);

  /// Creates a new [ColorMode] instance with the specified [value].
  const ColorMode(this.value);

  /// The integer value associated with this color mode in the PSD file format.
  final int value;

  /// Creates a [ColorMode] instance from its integer value.
  ///
  /// Returns the corresponding [ColorMode] if the [value] matches one of the
  /// defined color modes, or `null` if no matching color mode is found.
  ///
  /// Example:
  /// ```dart
  /// final mode = ColorMode.fromValue(3);
  /// print(mode); // ColorMode.rgb
  /// ```
  static ColorMode? fromValue(int value) {
    try {
      return ColorMode.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}
