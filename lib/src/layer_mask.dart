import 'dart:typed_data';
import 'layer_rect.dart';

/// A base class representing a mask in a Photoshop layer.
///
/// This class implements [LayerRect] and provides the common properties and
/// functionality shared by all types of masks in Photoshop. Masks are used
/// to control the visibility and transparency of different parts of a layer.
///
/// The class provides access to:
/// - Mask dimensions and position
/// - Mask data and file offset
/// - Mask properties (feather, density, default color)
///
/// Example usage:
/// ```dart
/// final mask = LayerMask();
/// mask.top = 0;
/// mask.left = 0;
/// mask.bottom = 100;
/// mask.right = 100;
/// mask.feather = 0.5;
/// mask.density = 100;
/// ```
class Mask implements LayerRect {
  /// The vertical position of the top edge of the mask's bounding rectangle.
  ///
  /// This value represents the y-coordinate of the topmost pixel of the mask,
  /// measured in pixels from the top edge of the layer.
  @override
  int? top;

  /// The horizontal position of the left edge of the mask's bounding rectangle.
  ///
  /// This value represents the x-coordinate of the leftmost pixel of the mask,
  /// measured in pixels from the left edge of the layer.
  @override
  int? left;

  /// The vertical position of the bottom edge of the mask's bounding rectangle.
  ///
  /// This value represents the y-coordinate of the bottommost pixel of the mask,
  /// measured in pixels from the top edge of the layer.
  @override
  int? bottom;

  /// The horizontal position of the right edge of the mask's bounding rectangle.
  ///
  /// This value represents the x-coordinate of the rightmost pixel of the mask,
  /// measured in pixels from the left edge of the layer.
  @override
  int? right;

  /// The file offset where the mask's data is stored in the PSD file.
  ///
  /// This value represents the byte offset from the start of the PSD file
  /// where the mask's data begins. It is used when reading mask data from
  /// the file or when writing mask data back to the file.
  ///
  /// A null value indicates that the file offset has not been set or that
  /// the mask's data is not stored in the file.
  int? fileOffset;

  /// The planar data for the mask.
  ///
  /// This property contains the actual mask data in planar format. The size
  /// of the data is determined by the mask's dimensions:
  /// `(right - left) * (bottom - top) * bytesPerPixel`
  ///
  /// The data is stored as a [Uint8List], where each byte represents a
  /// single pixel value in the mask. The values typically range from 0
  /// (fully transparent) to 255 (fully opaque).
  ///
  /// A null value indicates that no data has been loaded or allocated for
  /// this mask.
  Uint8List? data;

  /// The feather value of the mask.
  ///
  /// This value controls the softness of the mask's edges. A higher feather
  /// value creates a more gradual transition between masked and unmasked
  /// areas.
  ///
  /// The value is typically in the range [0.0, 1.0], where:
  /// - 0.0 represents no feathering (sharp edges)
  /// - 1.0 represents maximum feathering (very soft edges)
  double? feather;

  /// The density value of the mask.
  ///
  /// This value controls the overall opacity of the mask. A higher density
  /// value makes the mask more opaque, while a lower value makes it more
  /// transparent.
  ///
  /// The value is typically in the range [0, 100], where:
  /// - 0 represents completely transparent
  /// - 100 represents completely opaque
  int? density;

  /// The default color for regions outside the mask's bounding rectangle.
  ///
  /// This value determines the color used for areas that fall outside the
  /// mask's defined boundaries. It is typically used to specify whether
  /// areas outside the mask should be treated as transparent or opaque.
  ///
  /// The value is typically either 0 (transparent) or 255 (opaque).
  int? defaultColor;
}

/// A class representing a layer mask in a Photoshop layer.
///
/// A layer mask is a grayscale image that controls the visibility of different
/// parts of a layer. Black areas in the mask hide the corresponding parts of
/// the layer, while white areas show them. Gray areas create partial
/// transparency.
///
/// Layer masks are non-destructive, meaning they can be modified without
/// permanently altering the layer's content. They are commonly used for:
///
/// - Creating complex selections
/// - Blending multiple images
/// - Creating smooth transitions
/// - Non-destructive editing
///
/// This class extends [Mask] and inherits all its properties and functionality.
class LayerMask extends Mask {}

/// A class representing a vector mask in a Photoshop layer.
///
/// A vector mask uses vector graphics to define the visible areas of a layer.
/// Unlike layer masks, which use pixel-based data, vector masks use mathematical
/// paths to define their boundaries. This allows for:
///
/// - Crisp edges at any resolution
/// - Easy modification of mask shapes
/// - Precise control over mask boundaries
/// - Smaller file sizes for simple shapes
///
/// Vector masks are particularly useful for:
///
/// - Creating precise geometric shapes
/// - Working with text and logos
/// - Maintaining sharp edges when scaling
/// - Creating complex paths and shapes
///
/// This class extends [Mask] and inherits all its properties and functionality.
/// A struct representing a vector mask as stored in the layers of the Layer Mask section.
class VectorMask extends Mask {}
