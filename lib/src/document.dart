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

/// A class representing a Photoshop document and its contents.
///
/// This class serves as the central container for all information contained
/// in a PSD file. It provides access to:
///
/// - Document metadata (dimensions, color mode, etc.)
/// - Color mode data section
/// - Image resources section
/// - Layer mask information section
/// - Image data section
///
/// The class also provides methods to parse and access the contents of each
/// section, allowing for comprehensive manipulation of Photoshop documents.
///
/// Example usage:
/// ```dart
/// // Create a new document from a PSD file
/// final file = File.fromByteData(psdData);
/// final document = Document.fromFile(file);
///
/// // Parse and access different sections
/// final layerMaskSection = document.parseLayerMaskSection(file);
/// final imageDataSection = document.parseImageDataSection(file);
/// final resourcesSection = document.parseImageResourcesSection(file);
/// ```
class Document {
  /// Creates a new empty [Document] instance.
  ///
  /// The constructor initializes all sections with empty [Section] instances.
  /// The document will need to be populated with data from a PSD file or
  /// through programmatic manipulation.
  Document()
      : colorModeDataSection = Section(),
        imageResourcesSection = Section(),
        layerMaskInfoSection = Section(),
        imageDataSection = Section();

  /// The width of the document in pixels.
  int? width;

  /// The height of the document in pixels.
  int? height;

  /// The number of color channels in the document.
  ///
  /// This value represents the total number of color channels, including
  /// alpha channels and any additional channels beyond the standard RGB
  /// or CMYK channels.
  int? channelCount;

  /// The number of bits used to store each color channel.
  ///
  /// Common values are 8, 16, or 32 bits per channel. This affects the
  /// precision and range of color values that can be stored.
  int? bitsPerChannel;

  /// The color mode of the document.
  ///
  /// This property indicates how color information is stored in the document,
  /// such as RGB, CMYK, Grayscale, etc. It affects how the document's
  /// color data should be interpreted and processed.
  ColorMode? colorMode;

  /// The Color Mode Data section of the document.
  ///
  /// This section contains additional data specific to the document's color
  /// mode, such as color tables for indexed color modes or other color-related
  /// information.
  Section colorModeDataSection;

  /// The Image Resources section of the document.
  ///
  /// This section contains various resources associated with the document,
  /// such as paths, guides, color profiles, and other metadata.
  Section imageResourcesSection;

  /// The Layer Mask Info section of the document.
  ///
  /// This section contains information about the document's layers, including
  /// layer masks, layer properties, and layer hierarchy.
  Section layerMaskInfoSection;

  /// The Image Data section of the document.
  ///
  /// This section contains the actual pixel data for the document's layers
  /// and channels, including the merged image data.
  Section imageDataSection;

  /// Creates a new [Document] instance from a PSD file.
  ///
  /// This factory constructor parses the PSD file header and section offsets,
  /// returning a [Document] instance with the parsed information. It handles
  /// the initial parsing of the document structure and basic metadata.
  ///
  /// Parameters:
  /// - [file]: The PSD file to create the document from
  ///
  /// Returns a new [Document] instance containing the parsed information.
  ///
  /// Throws an [Exception] if:
  /// - The file is not a valid PSD file
  /// - The file header cannot be parsed
  /// - Any required section information is missing or invalid
  factory Document.fromFile(File file) {
    final document = createDocument(file);
    if (document == null) {
      throw Exception(popLastError("Failed to create document from file"));
    }
    return document;
  }

  /// Parses the Layer Mask section of the document.
  ///
  /// This method reads and parses the Layer Mask Info section from the PSD
  /// file, extracting information about layers, masks, and layer properties.
  ///
  /// Parameters:
  /// - [file]: The PSD file containing the layer mask data
  ///
  /// Returns a [LayerMaskSection] instance containing the parsed layer
  /// information, or null if parsing fails.
  LayerMaskSection? parseLayerMaskSection(File file) {
    parsedLayerMaskSection =
        parse_layer_mask_section.parseLayerMaskSection(this, file);
    return parsedLayerMaskSection;
  }

  /// Parses the Image Data section of the document.
  ///
  /// This method reads and parses the Image Data section from the PSD file,
  /// extracting the actual pixel data for the document's layers and channels.
  ///
  /// Parameters:
  /// - [file]: The PSD file containing the image data
  ///
  /// Returns an [ImageDataSection] instance containing the parsed image
  /// data, or null if parsing fails.
  ImageDataSection? parseImageDataSection(File file) {
    parsedImageDataSection =
        parse_image_data_section.parseImageDataSection(this, file);
    return parsedImageDataSection;
  }

  /// Parses the Image Resources section of the document.
  ///
  /// This method reads and parses the Image Resources section from the PSD
  /// file, extracting various resources and metadata associated with the
  /// document.
  ///
  /// Parameters:
  /// - [file]: The PSD file containing the image resources
  ///
  /// Returns an [ImageResourcesSection] instance containing the parsed
  /// resources, or null if parsing fails.
  ImageResourcesSection? parseImageResourcesSection(File file) {
    parsedImageResourcesSection =
        parse_image_resources_section.parseImageResourcesSection(this, file);
    return parsedImageResourcesSection;
  }

  /// The parsed Layer Mask section of the document.
  ///
  /// This property holds the parsed layer mask information after calling
  /// [parseLayerMaskSection]. It contains all layer-related data and
  /// properties.
  LayerMaskSection? parsedLayerMaskSection;

  /// The parsed Image Data section of the document.
  ///
  /// This property holds the parsed image data after calling
  /// [parseImageDataSection]. It contains the actual pixel data for
  /// the document's layers and channels.
  ImageDataSection? parsedImageDataSection;

  /// The parsed Image Resources section of the document.
  ///
  /// This property holds the parsed image resources after calling
  /// [parseImageResourcesSection]. It contains various resources and
  /// metadata associated with the document.
  ImageResourcesSection? parsedImageResourcesSection;
}
