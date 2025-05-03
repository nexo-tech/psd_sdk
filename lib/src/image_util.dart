import 'dart:typed_data';

import 'data_types.dart';

/// A utility class for handling image data operations in Photoshop documents.
///
/// This class provides methods for copying and manipulating image data between
/// different regions, such as copying layer data to a canvas while handling
/// various edge cases and optimizations.
///
/// The class supports different bit depths (8, 16, or 32 bits per channel)
/// and automatically handles the appropriate data type conversion.
///
/// Example usage:
/// ```dart
/// final layerData = Uint8List(layerWidth * layerHeight);
/// final canvasData = Uint8List(canvasWidth * canvasHeight);
/// final success = ImageUtil.copyLayerData(
///   layerData,
///   canvasData,
///   8,  // bits per channel
///   0,  // layer left
///   0,  // layer top
///   layerWidth,  // layer right
///   layerHeight, // layer bottom
///   canvasWidth,
///   canvasHeight
/// );
/// ```
class ImageUtil {
  /// Copies planar layer data to a canvas, handling overlapping regions.
  ///
  /// This method efficiently copies image data from a layer to a canvas,
  /// taking into account the position and size of both the layer and canvas.
  /// Only the parts of the layer that overlap with the canvas will be copied.
  ///
  /// The method supports different bit depths and automatically handles:
  /// - Layers completely outside the canvas
  /// - Layers exactly matching the canvas size
  /// - Partial overlaps between layer and canvas
  ///
  /// Parameters:
  /// - [layerData]: The source layer data to copy from
  /// - [canvasData]: The destination canvas data to copy to
  /// - [bitsPerChannel]: The number of bits per color channel (8, 16, or 32)
  /// - [layerLeft]: The left coordinate of the layer's bounding rectangle
  /// - [layerTop]: The top coordinate of the layer's bounding rectangle
  /// - [layerRight]: The right coordinate of the layer's bounding rectangle
  /// - [layerBottom]: The bottom coordinate of the layer's bounding rectangle
  /// - [canvasWidth]: The width of the canvas in pixels
  /// - [canvasHeight]: The height of the canvas in pixels
  ///
  /// Returns:
  /// `true` if the copy operation was successful, `false` if:
  /// - The bitsPerChannel value is not supported
  /// - The layer data is completely outside the canvas
  static bool copyLayerData(
      Uint8List layerData,
      Uint8List canvasData,
      int bitsPerChannel,
      int layerLeft,
      int layerTop,
      int layerRight,
      int layerBottom,
      int canvasWidth,
      int canvasHeight) {
    if (bitsPerChannel == 8) {
      _copyLayerData<Uint8T>(layerData, canvasData, layerLeft, layerTop,
          layerRight, layerBottom, canvasWidth, canvasHeight);
      return true;
    } else if (bitsPerChannel == 16) {
      _copyLayerData<Uint16T>(layerData, canvasData, layerLeft, layerTop,
          layerRight, layerBottom, canvasWidth, canvasHeight);
      return true;
    } else if (bitsPerChannel == 32) {
      _copyLayerData<Float32T>(layerData, canvasData, layerLeft, layerTop,
          layerRight, layerBottom, canvasWidth, canvasHeight);
      return true;
    } else {
      return false;
    }
  }
}

/// Checks if a layer's bounding rectangle is completely outside the canvas.
///
/// This helper function determines whether a layer's position and size
/// place it entirely outside the visible area of the canvas.
///
/// Parameters:
/// - [layerLeft]: The left coordinate of the layer's bounding rectangle
/// - [layerTop]: The top coordinate of the layer's bounding rectangle
/// - [layerRight]: The right coordinate of the layer's bounding rectangle
/// - [layerBottom]: The bottom coordinate of the layer's bounding rectangle
/// - [canvasWidth]: The width of the canvas in pixels
/// - [canvasHeight]: The height of the canvas in pixels
///
/// Returns:
/// `true` if the layer is completely outside the canvas, `false` otherwise.
bool _isOutside(int layerLeft, int layerTop, int layerRight, int layerBottom,
    int canvasWidth, int canvasHeight) {
  // layer data can be completely outside the canvas, or overlapping, or completely inside.
  // find the overlapping rectangle first.
  final w = (canvasWidth);
  final h = (canvasHeight);
  if ((layerLeft >= w) ||
      (layerTop >= h) ||
      (layerRight < 0) ||
      (layerBottom < 0)) {
    // layer data is completely outside
    return true;
  }

  return false;
}

/// Checks if a layer's bounding rectangle exactly matches the canvas dimensions.
///
/// This helper function determines whether a layer's position and size
/// perfectly align with the canvas boundaries.
///
/// Parameters:
/// - [layerLeft]: The left coordinate of the layer's bounding rectangle
/// - [layerTop]: The top coordinate of the layer's bounding rectangle
/// - [layerRight]: The right coordinate of the layer's bounding rectangle
/// - [layerBottom]: The bottom coordinate of the layer's bounding rectangle
/// - [canvasWidth]: The width of the canvas in pixels
/// - [canvasHeight]: The height of the canvas in pixels
///
/// Returns:
/// `true` if the layer's region exactly matches the canvas, `false` otherwise.
bool _isSameRegion(int layerLeft, int layerTop, int layerRight, int layerBottom,
    int canvasWidth, int canvasHeight) {
  final w = (canvasWidth);
  final h = (canvasHeight);
  if ((layerLeft == 0) &&
      (layerTop == 0) &&
      (layerRight == w) &&
      (layerBottom == h)) {
    // layer region exactly matches the canvas
    return true;
  }

  return false;
}

/// Internal implementation of layer data copying for a specific data type.
///
/// This function handles the actual copying of layer data to the canvas
/// for a specific numeric data type [T]. It implements several optimizations:
///
/// 1. Fast path for layers that exactly match the canvas size
/// 2. Efficient row-by-row copying for partial overlaps
/// 3. Proper handling of layer boundaries and canvas edges
///
/// Parameters:
/// - [layerData]: The source layer data to copy from
/// - [canvasData]: The destination canvas data to copy to
/// - [layerLeft]: The left coordinate of the layer's bounding rectangle
/// - [layerTop]: The top coordinate of the layer's bounding rectangle
/// - [layerRight]: The right coordinate of the layer's bounding rectangle
/// - [layerBottom]: The bottom coordinate of the layer's bounding rectangle
/// - [canvasWidth]: The width of the canvas in pixels
/// - [canvasHeight]: The height of the canvas in pixels
void _copyLayerData<T extends NumDataType>(
    Uint8List layerData,
    Uint8List canvasData,
    int layerLeft,
    int layerTop,
    int layerRight,
    int layerBottom,
    int canvasWidth,
    int canvasHeight) {
  final isOutside = _isOutside(
      layerLeft, layerTop, layerRight, layerBottom, canvasWidth, canvasHeight);
  if (isOutside) {
    return;
  }

  var isSameRegion = _isSameRegion(
      layerLeft, layerTop, layerRight, layerBottom, canvasWidth, canvasHeight);
  if (isSameRegion) {
    // fast path, the layer is exactly the same size as the canvas

    for (var x = 0; x < canvasWidth * canvasHeight * sizeof<T>(); x++) {
      canvasData[x] = layerData[x];
    }
    return;
  }

  // slower path, find the extents of the overlapping region to copy
  final w = (canvasWidth);
  final h = (canvasHeight);
  final left = layerLeft > 0 ? layerLeft : 0;
  final top = layerTop > 0 ? layerTop : 0;
  final right = layerRight < w ? layerRight : w;
  final bottom = layerBottom < h ? layerBottom : h;

  // setup source and destination data so we can copy row by row
  final regionWidth = right - left;
  final regionHeight = bottom - top;
  final planarWidth = layerRight - layerLeft;
  var srcOffset = 0 + (top - layerTop) * planarWidth + (left - layerLeft);
  var dstOffset = 0 + top * canvasWidth + (left);

  for (var y = 0; y < regionHeight; ++y) {
    for (var x = 0; x < (regionWidth) * sizeof<T>(); x++) {
      canvasData[dstOffset + x] = layerData[srcOffset + x];
    }
    dstOffset += canvasWidth;
    srcOffset += planarWidth;
  }
}
