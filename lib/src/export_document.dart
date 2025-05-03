import 'dart:typed_data';

import 'alpha_channel.dart';
import 'data_types.dart';
import 'export_channel.dart';
import 'export_layer.dart';
import 'export_metadata_attribute.dart';
import 'export_color_mode.dart';
import 'thumbnail.dart';
import 'export.dart';
import 'file.dart';
import 'compression_type.dart';

/// A struct representing a document to be exported.
class ExportDocument {
  static const maxAttributeCount = 128;
  static const maxLayerCount = 128;
  static const maxAlphaChannelCount = 128;

  final int width;
  final int height;
  final int bitsPerChannel;
  final ExportColorMode colorMode;

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

  /// Creates a new document suited for exporting a PSD file.
  ExportDocument(this.width, this.height, this.bitsPerChannel, this.colorMode) {
    attributes = [];
    layers = [];

    alphaChannels = [];

    iccProfile;

    exifData;

    thumbnail;
  }

  void write(File file) {
    writeDocument(this, file);
  }

  ExportLayer? addLayer(ExportDocument document, String name) {
    final index = document.layerCount;
    document.layers?.add(ExportLayer(index));

    var layer = document.layers?[index];
    if (layer == null) {
      return null;
    }
    layer.name = name;
    return layer;
  }

  /// Adds meta data to a document. The contents of name and value are copied. The returned index can be used to update existing meta data
  /// by a call to UpdateMetaData.
  ExportMetaDataAttribute addMetaData(String name, String value) {
    final index = attributeCount;
    final attribute = ExportMetaDataAttribute(index);
    attribute.name = name;
    attribute.value = value;
    attributes?.add(attribute);
    return attribute;
  }

  /// Updates a layer with planar data. The function internally takes ownership over all data, so planar image data passed to this function can be freed afterwards.
  /// Planar data must hold "width*height" bytes, where width = right - left and height = botttom - top.
  /// Note that individual layers can be smaller and/or larger than the canvas in PSD documents.
  void updateLayer<T extends TypedData>(
      ExportLayer layer,
      ExportChannel channel,
      int left,
      int top,
      int right,
      int bottom,
      TypedData planarData,
      CompressionType compression) {
    final layerIndex = layer.index;
    if (planarData is Uint8List) {
      updateLayerImpl<Uint8T>(this, layerIndex, channel, left, top, right,
          bottom, planarData, compression);
    } else if (planarData is Uint16List) {
      updateLayerImpl<Uint16T>(this, layerIndex, channel, left, top, right,
          bottom, planarData, compression);
    } else if (planarData is Float32List) {
      updateLayerImpl<Float32T>(this, layerIndex, channel, left, top, right,
          bottom, planarData, compression);
    } else {
      print('not supported');
    }
  }

  /// Updates the merged image data.
  /// Planar data must hold width*height bytes.
  void updateMergedImage(
      TypedData planarDataR, TypedData planarDataG, TypedData planarDataB) {
    if (planarDataR is Uint8List) {
      updateMergedImageImpl<Uint8T>(
          this, planarDataR, planarDataG, planarDataB);
    } else if (planarDataR is Uint16List) {
      updateMergedImageImpl<Uint16T>(
          this, planarDataR, planarDataG, planarDataB);
    } else if (planarDataR is Float32List) {
      updateMergedImageImpl<Float32T>(
          this, planarDataR, planarDataG, planarDataB);
    } else {
      print('unsupported');
    }
  }

  /// Adds an alpha channel to a document. The returned index can be used to update channel data by a call to updateChannel.
  int addAlphaChannel(
      String name, int r, int g, int b, int a, int opacity, int mode) {
    final index = alphaChannelCount;
    alphaChannels.add(AlphaChannel());

    var channel = alphaChannels[index];
    channel!.asciiName = name;
    channel.colorSpace = 0;
    channel.color[0] = r;
    channel.color[1] = g;
    channel.color[2] = b;
    channel.color[3] = a;
    channel.opacity = opacity;
    channel.mode = mode;

    return index;
  }

  /// Updates a layer with planar 32-bit data. The function internally takes ownership over all data, so planar image data passed to this function can be freed afterwards.
  /// Planar data must hold "width*height*4" bytes, where width = right - left and height = botttom - top.
  /// Note that individual layers can be smaller and/or larger than the canvas in PSD documents.
  void updateChannel(int channelIndex, TypedData data) {
    if (data is Uint8List) {
      updateChannelImpl<Uint8T>(this, channelIndex, data);
    } else if (data is Uint16List) {
      updateChannelImpl<Uint16T>(this, channelIndex, data);
    } else if (data is Float32List) {
      updateChannelImpl<Float32T>(this, channelIndex, data);
    } else {
      print('unsupported');
    }
  }
}
