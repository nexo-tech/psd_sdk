/// A namespace denoting a channel that is exported to the Layer Mask section.
enum ExportChannel {
  gray(0),
  red(1),
  green(2),
  blue(3),
  alpha(4);

  const ExportChannel(this.value);
  final int value;

  static ExportChannel? fromValue(int value) {
    try {
      return ExportChannel.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}
