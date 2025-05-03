/// A namespace denoting a color mode used for exporting a PSD document. Enumerator values denote the number of channels in the document as well as the PSD mode identifier.
enum ExportColorMode {
  grayscale(1),
  rgb(3);

  const ExportColorMode(this.value);
  final int value;

  static ExportColorMode? fromValue(int value) {
    try {
      return ExportColorMode.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}
