import 'dart:typed_data';

import 'alpha_channel.dart';
import 'export_layer.dart';
import 'export_metadata_attribute.dart';
import 'export_color_mode.dart';
import 'thumbnail.dart';

/// A struct representing a document to be exported.
class ExportDocument {
  static const maxAttributeCount = 128;
  static const maxLayerCount = 128;
  static const maxAlphaChannelCount = 128;

  int? width;
  int? height;
  int? bitsPerChannel;
  ExportColorMode? colorMode;

  List<ExportMetaDataAttribute>? attributes;
  int get attributeCount => attributes?.length ?? 0;

  List<ExportLayer>? layers;
  int get layerCount => layers?.length ?? 0;

  List<Uint8List?> mergedImageData = List<Uint8List?>.filled(3, null);

  List<AlphaChannel?> alphaChannels =
      List<AlphaChannel?>.filled(maxAlphaChannelCount, null);
  int get alphaChannelCount => alphaChannels.length;
  List<Uint8List?> alphaChannelData =
      List<Uint8List?>.filled(maxAlphaChannelCount, null);

  Uint8List? iccProfile;
  int get sizeOfICCProfile => iccProfile?.length ?? 0;

  Uint8List? exifData;
  int get sizeOfExifData => exifData?.length ?? 0;

  Thumbnail? thumbnail;
}
