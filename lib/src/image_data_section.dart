import 'dart:typed_data';
import 'package:psd_sdk/src/interleave.dart';

import 'document.dart';

/// A struct representing a planar image as stored in the Image Data section.
class PlanarImage {
  /// Planar data the size of the document's canvas.
  Uint8List? data;
}

/// A struct representing the information extracted from the Image Data section.
class ImageDataSection {
  /// An array of planar images, having imageCount entries.
  List<PlanarImage?>? images;

  /// The number of planar images stored in the array.
  int get imageCount => images?.length ?? 0;

  final Document document;

  // Constructor with document as argument
  ImageDataSection(this.document);

  Uint8List? getInterleavedImage([bool hasTransparencyMask = false]) {
    if (images == null) {
      return null;
    }

    bool isRgb;

    if (imageCount == 3) {
      isRgb = true;
    } else if (imageCount >= 4) {
      isRgb = !(hasTransparencyMask);
    } else {
      isRgb = false;
    }

    // Create interleaved image
    return isRgb
        ? interleaveRGB(
            images?[0]!.data,
            images?[1]!.data,
            images?[2]!.data,
            0,
            document.bitsPerChannel ?? 0,
            document.width ?? 0,
            document.height ?? 0)
        : interleaveRGBA(
            images?[0]!.data,
            images?[1]!.data,
            images?[2]!.data,
            images?[3]!.data,
            document.bitsPerChannel ?? 0,
            document.width ?? 0,
            document.height ?? 0);
  }
}
