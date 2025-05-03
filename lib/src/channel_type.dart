/// A channel holding constants to distinguish between the types of data a channel can hold.
enum ChannelType {
  /// Internal value. Used to denote that a channel no longer holds valid data.
  invalid(32767),

  /// Type denoting the R channel, not necessarily the first in a RGB Color Mode document.
  r(0),

  /// Type denoting the G channel, not necessarily the second in a RGB Color Mode document.
  g(1),

  /// Type denoting the B channel, not necessarily the third in a RGB Color Mode document.
  b(2),

  /// The layer's channel data is a transparency mask.
  transparencyMask(-1),

  /// The layer's channel data is either a layer or vector mask.
  layerOrVectorMask(-2),

  /// The layer's channel data is a layer mask.
  layerMask(-3);

  const ChannelType(this.value);
  final int value;

  static ChannelType? fromValue(int value) {
    try {
      return ChannelType.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}
