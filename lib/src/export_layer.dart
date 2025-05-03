import 'dart:typed_data';

/// A struct representing a layer as exported to the Layer Mask section.
class ExportLayer {
  // the SDK currently supports R, G, B, A
  static const int maxChannelCount = 4;

  int? top;
  int? left;
  int? bottom;
  int? right;
  String? name;

  var channelData = List<Uint8List?>.filled(maxChannelCount, null);
  var channelSize = Uint32List(maxChannelCount);
  var channelCompression = Uint16List(maxChannelCount);
}
