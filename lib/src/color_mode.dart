/// A class holding all color modes known by Photoshop.
enum ColorMode {
  /// BITMAP = 0
  bitmap(0),

  /// GRAYSCALE = 1
  grayscale(1),

  /// INDEXED = 2
  indexed(2),

  /// RGB = 3
  rgb(3),

  /// CMYK = 4
  cmyk(4),

  /// MULTICHANNEL = 7
  multichannel(7),

  /// DUOTONE = 8
  duotone(8),

  /// LAB = 9
  lab(9);

  const ColorMode(this.value);
  final int value;

  static ColorMode? fromValue(int value) {
    try {
      return ColorMode.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}
