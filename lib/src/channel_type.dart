/// A channel holding constants to distinguish between the types of data a channel can hold.
class ChannelType {
  /// Internal value. Used to denote that a channel no longer holds valid data.
  static const invalid = 32767;

  /// Type denoting the R channel, not necessarily the first in a RGB Color Mode document.
  static const r = 0;

  /// Type denoting the G channel, not necessarily the second in a RGB Color Mode document.
  static const g = 1;

  /// Type denoting the B channel, not necessarily the third in a RGB Color Mode document.
  static const b = 2;

  /// The layer's channel data is a transparency mask.
  static const transparencyMask = -1;

  /// The layer's channel data is either a layer or vector mask.
  static const layerOrVectorMask = -2;

  /// The layer's channel data is a layer mask.
  static const layerMask = -3;
}
