import 'dart:typed_data';
import 'data_types.dart';

/// Converts planar RGB color data into interleaved RGBA format with a constant alpha value.
///
/// This function takes separate planar buffers for red, green, and blue channels
/// and combines them into a single interleaved RGBA buffer. The alpha channel
/// is set to a constant value for all pixels.
///
/// The function supports different bit depths (8, 16, or 32 bits per channel)
/// and automatically handles the appropriate data type conversion.
///
/// Parameters:
/// - [srcR]: The source buffer containing red channel data
/// - [srcG]: The source buffer containing green channel data
/// - [srcB]: The source buffer containing blue channel data
/// - [alpha]: The constant alpha value to use for all pixels
/// - [bitsPerChannel]: The number of bits per color channel (8, 16, or 32)
/// - [width]: The width of the image in pixels
/// - [height]: The height of the image in pixels
/// - [blockSize]: The block size for memory alignment (default: 4)
///
/// Returns:
/// A [Uint8List] containing the interleaved RGBA data, or null if:
/// - Any of the source buffers are null
/// - The bitsPerChannel value is not supported
///
/// Example usage:
/// ```dart
/// final redChannel = Uint8List(width * height);
/// final greenChannel = Uint8List(width * height);
/// final blueChannel = Uint8List(width * height);
/// final rgbaData = interleaveRGB(
///   redChannel,
///   greenChannel,
///   blueChannel,
///   255,  // alpha value
///   8,    // bits per channel
///   width,
///   height
/// );
/// ```
Uint8List? interleaveRGB(Uint8List? srcR, Uint8List? srcG, Uint8List? srcB,
    num alpha, int bitsPerChannel, int width, int height,
    [int blockSize = 4]) {
  if (bitsPerChannel == 8) {
    return _interleaveRGB<Uint8T>(srcR, srcG, srcB, alpha, width, height);
  } else if (bitsPerChannel == 16) {
    return _interleaveRGB<Uint16T>(srcR, srcG, srcB, alpha, width, height);
  } else if (bitsPerChannel == 32) {
    return _interleaveRGB<Float32T>(srcR, srcG, srcB, alpha, width, height);
  }
  return null;
}

/// Converts planar RGBA color data into interleaved RGBA format.
///
/// This function takes separate planar buffers for red, green, blue, and alpha
/// channels and combines them into a single interleaved RGBA buffer.
///
/// The function supports different bit depths (8, 16, or 32 bits per channel)
/// and automatically handles the appropriate data type conversion.
///
/// Parameters:
/// - [srcR]: The source buffer containing red channel data
/// - [srcG]: The source buffer containing green channel data
/// - [srcB]: The source buffer containing blue channel data
/// - [srcA]: The source buffer containing alpha channel data
/// - [bitsPerChannel]: The number of bits per color channel (8, 16, or 32)
/// - [width]: The width of the image in pixels
/// - [height]: The height of the image in pixels
/// - [blockSize]: The block size for memory alignment (default: 4)
///
/// Returns:
/// A [Uint8List] containing the interleaved RGBA data, or null if:
/// - Any of the source buffers are null
/// - The bitsPerChannel value is not supported
///
/// Example usage:
/// ```dart
/// final redChannel = Uint8List(width * height);
/// final greenChannel = Uint8List(width * height);
/// final blueChannel = Uint8List(width * height);
/// final alphaChannel = Uint8List(width * height);
/// final rgbaData = interleaveRGBA(
///   redChannel,
///   greenChannel,
///   blueChannel,
///   alphaChannel,
///   8,    // bits per channel
///   width,
///   height
/// );
/// ```
Uint8List? interleaveRGBA(Uint8List? srcR, Uint8List? srcG, Uint8List? srcB,
    Uint8List? srcA, int bitsPerChannel, int width, int height,
    [int blockSize = 4]) {
  if (bitsPerChannel == 8) {
    return _interleaveRGBA<Uint8T>(srcR, srcG, srcB, srcA, width, height);
  } else if (bitsPerChannel == 16) {
    return _interleaveRGBA<Uint16T>(srcR, srcG, srcB, srcA, width, height);
  } else if (bitsPerChannel == 32) {
    return _interleaveRGBA<Float32T>(srcR, srcG, srcB, srcA, width, height);
  }
  return null;
}

/// Internal implementation of RGB to RGBA interleaving for a specific data type.
///
/// This function handles the actual conversion of planar RGB data to interleaved
/// RGBA format for a specific numeric data type [T]. It is called by the public
/// [interleaveRGB] function after determining the appropriate data type.
///
/// Parameters:
/// - [srcR]: The source buffer containing red channel data
/// - [srcG]: The source buffer containing green channel data
/// - [srcB]: The source buffer containing blue channel data
/// - [alpha]: The constant alpha value to use for all pixels
/// - [width]: The width of the image in pixels
/// - [height]: The height of the image in pixels
/// - [blockSize]: The block size for memory alignment (default: 4)
///
/// Returns:
/// A [Uint8List] containing the interleaved RGBA data, or null if any source
/// buffer is null.
Uint8List? _interleaveRGB<T extends NumDataType>(Uint8List? srcR,
    Uint8List? srcG, Uint8List? srcB, num alpha, int width, int height,
    [int blockSize = 4]) {
  if (srcR == null || srcG == null || srcB == null) {
    return null;
  }
  final r = getTypedList<T>(srcR) as List;
  final g = getTypedList<T>(srcG) as List;
  final b = getTypedList<T>(srcB) as List;

  if (isDouble<T>()) {
    alpha = alpha.toDouble();
  }
  var dest = Uint8List(width * height * 4 * sizeof<T>());
  var destTyped = getTypedList<T>(dest) as List;

  for (var x = 0; x < width * height; x++) {
    destTyped[x * 4 + 0] = r[x];
    destTyped[x * 4 + 1] = g[x];
    destTyped[x * 4 + 2] = b[x];
    destTyped[x * 4 + 3] = alpha;
  }
  return dest;
}

/// Internal implementation of RGBA to RGBA interleaving for a specific data type.
///
/// This function handles the actual conversion of planar RGBA data to interleaved
/// RGBA format for a specific numeric data type [T]. It is called by the public
/// [interleaveRGBA] function after determining the appropriate data type.
///
/// Parameters:
/// - [srcR]: The source buffer containing red channel data
/// - [srcG]: The source buffer containing green channel data
/// - [srcB]: The source buffer containing blue channel data
/// - [srcA]: The source buffer containing alpha channel data
/// - [width]: The width of the image in pixels
/// - [height]: The height of the image in pixels
/// - [blockSize]: The block size for memory alignment (default: 4)
///
/// Returns:
/// A [Uint8List] containing the interleaved RGBA data, or null if any source
/// buffer is null.
Uint8List? _interleaveRGBA<T extends NumDataType>(Uint8List? srcR,
    Uint8List? srcG, Uint8List? srcB, Uint8List? srcA, int width, int height,
    [int blockSize = 4]) {
  if (srcR == null || srcG == null || srcB == null || srcA == null) {
    return null;
  }
  final r = getTypedList<T>(srcR) as List;
  final g = getTypedList<T>(srcG) as List;
  final b = getTypedList<T>(srcB) as List;
  final a = getTypedList<T>(srcA) as List;

  var dest = Uint8List(width * height * 4 * sizeof<T>());
  var destTyped = getTypedList<T>(dest) as List;

  for (var x = 0; x < width * height; x++) {
    destTyped[x * 4 + 0] = r[x];
    destTyped[x * 4 + 1] = g[x];
    destTyped[x * 4 + 2] = b[x];
    destTyped[x * 4 + 3] = a[x];
  }
  return dest;
}
