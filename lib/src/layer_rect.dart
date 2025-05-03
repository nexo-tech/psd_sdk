/// An interface defining the rectangular boundaries of a layer in a Photoshop document.
///
/// This interface represents the spatial dimensions of a layer within a Photoshop
/// document. It defines the four edges of the layer's bounding rectangle:
/// - [top]: The vertical position of the top edge
/// - [left]: The horizontal position of the left edge
/// - [bottom]: The vertical position of the bottom edge
/// - [right]: The horizontal position of the right edge
///
/// All coordinates are measured in pixels relative to the document's origin
/// (typically the top-left corner). The coordinates can be null to indicate
/// that the layer's position is not yet defined.
///
/// Example usage:
/// ```dart
/// class MyLayer implements LayerRect {
///   @override
///   int? top;
///   @override
///   int? left;
///   @override
///   int? bottom;
///   @override
///   int? right;
/// }
/// ```
class LayerRect {
  /// The horizontal position of the right edge of the layer.
  ///
  /// This value represents the x-coordinate of the rightmost pixel of the layer,
  /// measured in pixels from the left edge of the document.
  int? right;

  /// The horizontal position of the left edge of the layer.
  ///
  /// This value represents the x-coordinate of the leftmost pixel of the layer,
  /// measured in pixels from the left edge of the document.
  int? left;

  /// The vertical position of the top edge of the layer.
  ///
  /// This value represents the y-coordinate of the topmost pixel of the layer,
  /// measured in pixels from the top edge of the document.
  int? top;

  /// The vertical position of the bottom edge of the layer.
  ///
  /// This value represents the y-coordinate of the bottommost pixel of the layer,
  /// measured in pixels from the top edge of the document.
  int? bottom;
}
