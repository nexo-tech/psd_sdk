import 'package:psd_sdk/src/section.dart';
import 'package:psd_sdk/src/color_mode.dart';

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
}
