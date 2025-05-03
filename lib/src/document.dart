import 'package:psd_sdk/src/image_data_section.dart';
import 'package:psd_sdk/src/log.dart';
import 'package:psd_sdk/src/section.dart';
import 'package:psd_sdk/src/color_mode.dart';
import 'package:psd_sdk/src/file.dart';
import 'package:psd_sdk/src/parse_document.dart';
import 'package:psd_sdk/src/layer_mask_section.dart';
import 'package:psd_sdk/src/parse_layer_mask_section.dart'
    as parse_layer_mask_section;
import 'package:psd_sdk/src/parse_image_data_section.dart'
    as parse_image_data_section;
import 'package:psd_sdk/src/parse_image_resources_section.dart'
    as parse_image_resources_section;
import 'package:psd_sdk/src/image_resources_section.dart';

/// A struct storing the document-wide information and sections contained in a .PSD file.
class Document {
  Document()
      : colorModeDataSection = Section(),
        imageResourcesSection = Section(),
        layerMaskInfoSection = Section(),
        imageDataSection = Section();

  int? width;
  int? height;
  int? channelCount;
  int? bitsPerChannel;
  ColorMode? colorMode;

  /// Color mode data section.
  Section colorModeDataSection;

  /// Image Resources section.
  Section imageResourcesSection;

  /// Layer Mask Info section.
  Section layerMaskInfoSection;

  /// Image Data section.
  Section imageDataSection;

  /// Creates a new [Document] from a PSD file.
  ///
  /// This factory constructor parses the PSD file header and section offsets,
  /// returning a [Document] instance with the parsed information.
  ///
  /// Returns `null` if the file is not a valid PSD file or if parsing fails.
  factory Document.fromFile(File file) {
    final document = createDocument(file);
    if (document == null) {
      throw Exception(popLastError("Failed to create document from file"));
    }
    return document;
  }

  LayerMaskSection? parseLayerMaskSection(File file) {
    parsedLayerMaskSection =
        parse_layer_mask_section.parseLayerMaskSection(this, file);
    return parsedLayerMaskSection;
  }

  ImageDataSection? parseImageDataSection(File file) {
    parsedImageDataSection =
        parse_image_data_section.parseImageDataSection(this, file);
    return parsedImageDataSection;
  }

  ImageResourcesSection? parseImageResourcesSection(File file) {
    parsedImageResourcesSection =
        parse_image_resources_section.parseImageResourcesSection(this, file);
    return parsedImageResourcesSection;
  }

  LayerMaskSection? parsedLayerMaskSection;
  ImageDataSection? parsedImageDataSection;
  ImageResourcesSection? parsedImageResourcesSection;
}
