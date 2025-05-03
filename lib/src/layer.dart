import 'dart:typed_data';

import 'channel.dart';
import 'channel_type.dart';
import 'layer_mask.dart';
import 'layer_rect.dart';
import 'layer_type.dart';
import 'document.dart';
import 'file.dart';
import 'parse_layer_mask_section.dart' as parse_layer_mask_section;

/// A class representing a layer in a Photoshop document.
///
/// This class implements the [LayerRect] interface and encapsulates all the
/// properties and functionality of a Photoshop layer, including:
///
/// - Layer dimensions and position
/// - Channel data and masks
/// - Layer properties (opacity, blend mode, visibility)
/// - Layer hierarchy (parent-child relationships)
/// - Layer names in both ASCII and UTF-16 formats
///
/// The class provides methods to:
/// - Extract layer data from PSD files
/// - Find specific channels within the layer
/// - Access layer properties and metadata
///
/// Example usage:
/// ```dart
/// final layer = Layer(document);
/// layer.name = "Background";
/// layer.isVisible = true;
/// layer.opacity = 255; // 100% opacity
///
/// // Find a specific channel
/// final redChannel = layer.findChannel(ChannelType.red);
/// ```
class Layer implements LayerRect {
  /// Creates a new [Layer] instance associated with the given [document].
  ///
  /// The layer is initialized with default values and is ready to be populated
  /// with data from a PSD file or through programmatic manipulation.
  Layer(this.document);

  /// The document that this layer belongs to.
  final Document document;

  /// The parent layer of this layer, if it exists.
  ///
  /// This property establishes the layer hierarchy within the document.
  /// A null value indicates that this layer is at the root level.
  Layer? parent;

  /// The ASCII name of the layer.
  ///
  /// In PSD files, layer names are limited to 31 characters. If a longer name
  /// is provided, it will be truncated when saving to a PSD file.
  String? name;

  /// The UTF-16 encoded name of the layer.
  ///
  /// This property stores the layer name in UTF-16 format, which supports
  /// a wider range of characters than ASCII. This is particularly useful for
  /// international character sets.
  Uint16List? utf16Name;

  /// The top coordinate of the layer's bounding rectangle.
  ///
  /// This value represents the vertical position of the top edge of the layer
  /// relative to the document's top edge.
  @override
  int? top;

  /// The left coordinate of the layer's bounding rectangle.
  ///
  /// This value represents the horizontal position of the left edge of the layer
  /// relative to the document's left edge.
  @override
  int? left;

  /// The bottom coordinate of the layer's bounding rectangle.
  ///
  /// This value represents the vertical position of the bottom edge of the layer
  /// relative to the document's top edge.
  @override
  int? bottom;

  /// The right coordinate of the layer's bounding rectangle.
  ///
  /// This value represents the horizontal position of the right edge of the layer
  /// relative to the document's left edge.
  @override
  int? right;

  /// The list of channels associated with this layer.
  ///
  /// Each channel represents a color component or mask of the layer.
  /// Common channels include red, green, blue, and alpha channels.
  List<Channel?>? channels;

  /// Returns the number of channels in this layer.
  ///
  /// This getter provides a convenient way to access the total number of
  /// channels without having to check for null values in the channels list.
  int get channelCount => channels?.length ?? 0;

  /// The layer mask associated with this layer, if any.
  ///
  /// A layer mask allows for non-destructive editing by controlling the
  /// visibility of different parts of the layer.
  LayerMask? layerMask;

  /// The vector mask associated with this layer, if any.
  ///
  /// A vector mask uses vector graphics to define the visible areas of the layer,
  /// allowing for crisp edges at any resolution.
  VectorMask? vectorMask;

  /// The blend mode key for this layer.
  ///
  /// This value determines how this layer blends with the layers below it.
  /// The key corresponds to one of the values in the blendMode::Enum.
  int? blendModeKey;

  /// The opacity of the layer.
  ///
  /// This value represents the layer's transparency, where:
  /// - 0 represents completely transparent (0%)
  /// - 255 represents completely opaque (100%)
  int? opacity;

  /// The clipping mode of the layer.
  ///
  /// This property determines how the layer interacts with the layer below it
  /// in terms of transparency and blending.
  ///
  /// Note: This property is currently not used in the implementation.
  int? clipping;

  /// The type of this layer.
  ///
  /// This property indicates the specific type of layer, which can be any value
  /// from the [LayerType] enum. The type affects how the layer is processed
  /// and displayed.
  LayerType type = LayerType.any;

  /// Indicates whether the layer is visible in the document.
  ///
  /// When true, the layer is visible and contributes to the final image.
  /// When false, the layer is hidden and does not affect the final image.
  bool? isVisible;

  /// Extracts the layer data from a PSD file.
  ///
  /// This method reads the layer information from the provided [file] and
  /// populates this layer instance with the extracted data.
  ///
  /// Parameters:
  /// - [file]: The PSD file to extract the layer data from
  void extract(File file) {
    parse_layer_mask_section.extractLayer(document, file, this);
  }

  /// Finds a specific channel within this layer.
  ///
  /// This method searches through the layer's channels to find one that matches
  /// the specified [channelType] and has associated data.
  ///
  /// Parameters:
  /// - [channelType]: The type of channel to find
  ///
  /// Returns the matching [Channel] if found, or null if no matching channel
  /// with data exists.
  Channel? findChannel(ChannelType channelType) {
    for (var i = 0; i < channelCount; ++i) {
      var channel = channels![i];
      if (channel!.data != null && channel.type == channelType) {
        return channel;
      }
    }
    return null;
  }
}
