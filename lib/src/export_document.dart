import 'dart:typed_data';

import 'alpha_channel.dart';
import 'export_layer.dart';
import 'export_metadata_attribute.dart';
import 'thumbnail.dart';

/// A struct representing a document to be exported.
class ExportDocument {
  static const MAX_ATTRIBUTE_COUNT = 128;
  static const MAX_LAYER_COUNT = 128;
  static const MAX_ALPHA_CHANNEL_COUNT = 128;

  int? width;
  int? height;
  int? bitsPerChannel;
  int? colorMode;

  List<ExportMetaDataAttribute>? attributes;
  int get attributeCount => attributes?.length ?? 0;

  List<ExportLayer>? layers;
  int get layerCount => layers?.length ?? 0;

  List<Uint8List?> mergedImageData = List<Uint8List?>.filled(3, null);

  List<AlphaChannel?> alphaChannels =
      List<AlphaChannel?>.filled(MAX_ALPHA_CHANNEL_COUNT, null);
  int get alphaChannelCount => alphaChannels.length;
  List<Uint8List?> alphaChannelData =
      List<Uint8List?>.filled(MAX_ALPHA_CHANNEL_COUNT, null);

  Uint8List? iccProfile;
  int get sizeOfICCProfile => iccProfile?.length ?? 0;

  Uint8List? exifData;
  int get sizeOfExifData => exifData?.length ?? 0;

  Thumbnail? thumbnail;
}
