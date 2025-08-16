import 'dart:typed_data';

import 'alpha_channel.dart';
import 'data_types.dart';
import 'export_channel.dart';
import 'export_layer.dart';
import 'export_metadata_attribute.dart';
import 'export_color_mode.dart';
import 'thumbnail.dart';
import 'export.dart';
import 'log.dart';
import 'file.dart';
import 'compression_type.dart';

/// A class representing a Photoshop document for export operations.
///
/// This class provides a comprehensive interface for creating and manipulating
/// Photoshop documents programmatically. It supports various document features
/// including:
///
/// - Multiple layers with different dimensions
/// - Alpha channels
/// - Metadata attributes
/// - ICC profiles
/// - EXIF data
/// - Thumbnails
/// - Different color modes and bit depths
///
/// The class maintains internal state for all document components and provides
/// methods to update and modify them. It also handles the conversion of raw
/// image data into the appropriate format for PSD files.
///
/// Example usage:
/// ```dart
/// // Create a new document
/// final doc = ExportDocument(800, 600, 8, ExportColorMode.rgb);
///
/// // Add a layer
/// final layer = doc.addLayer(doc, "Background");
///
/// // Update layer with image data
/// doc.updateLayer(
///   layer!,
///   ExportChannel.red,
///   0, 0, 800, 600,
///   Uint8List(800 * 600),
///   CompressionType.rle
/// );
///
/// // Add metadata
/// doc.addMetaData("Author", "John Doe");
///
/// // Write to file
/// doc.write(File());
/// ```
class ExportDocument {
  /// Maximum number of metadata attributes allowed in a document.
  static const maxAttributeCount = 128;

  /// Maximum number of layers allowed in a document.
  static const maxLayerCount = 128;

  /// Maximum number of alpha channels allowed in a document.
  static const maxAlphaChannelCount = 128;

  /// The width of the document in pixels.
  final int width;

  /// The height of the document in pixels.
  final int height;

  /// The number of bits per color channel.
  ///
  /// Common values are 8, 16, or 32 bits per channel.
  final int bitsPerChannel;

  /// The color mode of the document.
  final ExportColorMode colorMode;

  /// List of metadata attributes associated with the document.
  List<ExportMetaDataAttribute>? attributes;

  /// Returns the number of metadata attributes in the document.
  int get attributeCount => attributes?.length ?? 0;

  /// List of layers in the document.
  List<ExportLayer>? layers;

  /// Returns the number of layers in the document.
  int get layerCount => layers?.length ?? 0;

  /// Storage for merged image data in RGB format.
  ///
  /// Each element represents a color channel (R, G, B).
  List<Uint8List?> mergedImageData = List<Uint8List?>.filled(3, null);

  /// List of alpha channels in the document.
  List<AlphaChannel?> alphaChannels =
      List<AlphaChannel?>.filled(maxAlphaChannelCount, null);

  /// Returns the number of alpha channels in the document.
  int get alphaChannelCount => alphaChannels.length;

  /// Storage for alpha channel data.
  List<Uint8List?> alphaChannelData =
      List<Uint8List?>.filled(maxAlphaChannelCount, null);

  /// ICC profile data for color management.
  Uint8List? iccProfile;

  /// Returns the size of the ICC profile in bytes.
  int get sizeOfICCProfile => iccProfile?.length ?? 0;

  /// EXIF metadata associated with the document.
  Uint8List? exifData;

  /// Returns the size of the EXIF data in bytes.
  int get sizeOfExifData => exifData?.length ?? 0;

  /// Thumbnail image for the document.
  Thumbnail? thumbnail;

  /// Creates a new [ExportDocument] instance with the specified dimensions and color settings.
  ///
  /// The document is initialized with empty lists for layers and attributes,
  /// and null values for other properties that can be set later.
  ///
  /// Parameters:
  /// - [width]: The width of the document in pixels
  /// - [height]: The height of the document in pixels
  /// - [bitsPerChannel]: The number of bits per color channel (typically 8, 16, or 32)
  /// - [colorMode]: The color mode of the document
  ExportDocument(this.width, this.height, this.bitsPerChannel, this.colorMode) {
    attributes = [];
    layers = [];
    alphaChannels = [];
    iccProfile;
    exifData;
    thumbnail;
  }

  /// Writes the document to a [File] instance.
  ///
  /// This method initiates the export process, converting the document's
  /// internal representation into a PSD file format.
  void write(File file) {
    writeDocument(this, file);
  }

  /// Adds a new layer to the document.
  ///
  /// Creates a new layer with the specified name and adds it to the document's
  /// layer list. The layer is initialized with default properties.
  ///
  /// Parameters:
  /// - [document]: The document to add the layer to
  /// - [name]: The name of the new layer
  ///
  /// Returns the newly created [ExportLayer] instance, or null if the operation failed.
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

  /// Adds metadata to the document.
  ///
  /// Creates a new metadata attribute with the specified name and value.
  /// The contents of both name and value are copied internally.
  ///
  /// Parameters:
  /// - [name]: The name of the metadata attribute
  /// - [value]: The value of the metadata attribute
  ///
  /// Returns the created [ExportMetaDataAttribute] instance.
  ExportMetaDataAttribute addMetaData(String name, String value) {
    final index = attributeCount;
    final attribute = ExportMetaDataAttribute(index);
    attribute.name = name;
    attribute.value = value;
    attributes?.add(attribute);
    return attribute;
  }

  /// Updates a layer with planar image data.
  ///
  /// This method takes ownership of the provided data and updates the specified
  /// layer's channel with the new image data. The data must be in planar format
  /// and match the specified dimensions.
  ///
  /// Parameters:
  /// - [layer]: The layer to update
  /// - [channel]: The color channel to update
  /// - [left]: Left coordinate of the update region
  /// - [top]: Top coordinate of the update region
  /// - [right]: Right coordinate of the update region
  /// - [bottom]: Bottom coordinate of the update region
  /// - [planarData]: The image data in planar format
  /// - [compression]: The compression type to use
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
      psdWarning([
        'ExportDocument',
        'Unsupported data type for updateLayer:',
        planarData.runtimeType.toString()
      ]);
    }
  }

  /// Updates the merged image data with new RGB values.
  ///
  /// This method updates the document's merged image data with new planar data
  /// for each color channel. The data must match the document's dimensions.
  ///
  /// Parameters:
  /// - [planarDataR]: Red channel data
  /// - [planarDataG]: Green channel data
  /// - [planarDataB]: Blue channel data
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
      psdWarning([
        'ExportDocument',
        'Unsupported data type for updateMergedImage:',
        planarDataR.runtimeType.toString()
      ]);
    }
  }

  /// Adds a new alpha channel to the document.
  ///
  /// Creates a new alpha channel with the specified properties and adds it to
  /// the document's alpha channel list.
  ///
  /// Parameters:
  /// - [name]: The name of the alpha channel
  /// - [r]: Red component of the channel color
  /// - [g]: Green component of the channel color
  /// - [b]: Blue component of the channel color
  /// - [a]: Alpha component of the channel color
  /// - [opacity]: The opacity of the channel
  /// - [mode]: The blend mode of the channel
  ///
  /// Returns the index of the newly created alpha channel.
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

  /// Updates an alpha channel with new data.
  ///
  /// This method updates the specified alpha channel with new image data.
  /// The data must match the document's dimensions.
  ///
  /// Parameters:
  /// - [channelIndex]: The index of the channel to update
  /// - [data]: The new channel data
  void updateChannel(int channelIndex, TypedData data) {
    if (data is Uint8List) {
      updateChannelImpl<Uint8T>(this, channelIndex, data);
    } else if (data is Uint16List) {
      updateChannelImpl<Uint16T>(this, channelIndex, data);
    } else if (data is Float32List) {
      updateChannelImpl<Float32T>(this, channelIndex, data);
    } else {
      psdWarning([
        'ExportDocument',
        'Unsupported data type for updateChannel:',
        data.runtimeType.toString()
      ]);
    }
  }
}
