import 'layer.dart';

/// A class representing the Layer Mask section of a Photoshop document.
///
/// This class encapsulates the information extracted from the Layer Mask section
/// of a PSD file, which contains metadata and settings related to layer masks
/// and transparency. The Layer Mask section is a critical part of the PSD file
/// format that stores information about layer visibility, transparency, and
/// blending modes.
///
/// The class provides access to:
/// - Individual layers and their properties
/// - Global layer settings
/// - Transparency mask information
/// - Overlay color space settings
///
/// Example usage:
/// ```dart
/// final section = LayerMaskSection();
/// section.layers = [Layer()];
/// print(section.layerCount); // 1
/// ```
class LayerMaskSection {
  /// The list of layers contained in the Layer Mask section.
  ///
  /// Each element in the list represents a layer in the Photoshop document.
  /// The layers are stored in the order they appear in the document, from
  /// bottom to top. Each layer contains its own mask and transparency
  /// information.
  List<Layer?>? layers;

  /// Returns the number of layers in the Layer Mask section.
  ///
  /// This getter provides a convenient way to access the total number of
  /// layers without having to check for null values in the layers list.
  int get layerCount => layers?.length ?? 0;

  /// The color space used for layer overlays.
  ///
  /// This property represents the color space in which layer overlays are
  /// defined. While this value is part of the PSD file format, its exact
  /// usage and interpretation are not fully documented by Adobe.
  ///
  /// Note: This property is currently not used in the implementation.
  int? overlayColorSpace;

  /// The global opacity level for the layer mask section.
  ///
  /// This value represents the overall transparency of the layer mask section,
  /// where:
  /// - 0 represents completely transparent
  /// - 100 represents completely opaque
  ///
  /// Note: This property is currently not used in the implementation.
  int? opacity;

  /// The global layer type or kind.
  ///
  /// This property indicates the overall type of layer mask section, which
  /// can affect how layers are processed and displayed.
  ///
  /// Note: This property is currently not used in the implementation.
  int? kind;

  /// Indicates whether the layer data includes a transparency mask.
  ///
  /// When true, this indicates that the layer data contains additional
  /// transparency information beyond the standard alpha channel. This can
  /// be used for more complex transparency effects and layer compositing.
  bool? hasTransparencyMask;
}
