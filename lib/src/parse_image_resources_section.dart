import 'package:psd_sdk/src/key.dart';
import 'package:psd_sdk/src/log.dart';

import 'alpha_channel.dart';
import 'bit_util.dart';
import 'document.dart';
import 'file.dart';
import 'image_resource_type.dart';
import 'image_resources_section.dart';
import 'sync_file_reader.dart';
import 'thumbnail.dart';

/// Parses the image resources section in the document, and returns a newly created instance.
/// It is valid to parse different sections of a document (e.g. using parseImageResourcesSection, parseImageDataSection,
/// or parseLayerMaskSection) in parallel from different threads.
ImageResourcesSection parseImageResourcesSection(Document document, File file) {
  final imageResources = ImageResourcesSection();

  imageResources.alphaChannels = null;
  imageResources.iccProfile = null;
  imageResources.sizeOfICCProfile = 0;
  imageResources.exifData = null;
  imageResources.sizeOfExifData = 0;
  imageResources.containsRealMergedData = true;
  imageResources.xmpMetadata = null;
  imageResources.thumbnail = null;

  final reader = SyncFileReader(file);
  reader.setPosition(document.imageResourcesSection.offset ?? 0);

  var leftToRead = document.imageResourcesSection.length ?? 0;
  while (leftToRead > 0) {
    final signature = reader.readUint32();
    if ((signature != keyValue('8BIM')) && (signature != keyValue('psdM'))) {
      psdError([
        'ImageResources',
        'Image resources section seems to be corrupt, signature does not match "8BIM".'
      ]);
      return imageResources;
    }

    final id = reader.readUint16();

    // the resource name is stored as a Pascal string. note that the string is padded to make the size even.
    final nameLength = reader.readByte();
    final paddedNameLength = roundUpToMultiple(nameLength + 1, 2);
    // ignore: unused_local_variable
    final name = reader.readBytes(paddedNameLength - 1);

    // the resource data size is also padded to make the size even
    var resourceSize = reader.readUint32();
    resourceSize = roundUpToMultiple(resourceSize, 2);

    switch (id) {
      case ImageResource.iptcNaa:
      case ImageResource.captionDigest:
      case ImageResource.printInformation:
      case ImageResource.printStyle:
      case ImageResource.printScale:
      case ImageResource.printFlags:
      case ImageResource.printFlagsInfo:
      case ImageResource.printInfo:
      case ImageResource.resolutionInfo:
        // we are currently not interested in this resource, skip it
        reader.skip(resourceSize);
        break;

      case ImageResource.displayInfo:
        {
          // the display info resource stores color information and opacity for extra channels contained
          // in the document. these extra channels could be alpha/transparency, as well as spot color
          // channels used for printing.

          // check whether storage for alpha channels has been allocated yet
          // (imageResource::ALPHA_CHANNEL_ASCII_NAMES stores the channel names)
          if (imageResources.alphaChannels == null) {
            // note that this assumes RGB mode
            final channelCount = document.channelCount ?? 0 - 3;
            imageResources.alphaChannels =
                List<AlphaChannel>.filled(channelCount, AlphaChannel());
          }

          // ignore: unused_local_variable
          final version = reader.readUint32();

          for (var i = 0; i < imageResources.alphaChannelCount; ++i) {
            var channel = imageResources.alphaChannels![0];
            channel.colorSpace = reader.readUint16();
            channel.color[0] = reader.readUint16();
            channel.color[1] = reader.readUint16();
            channel.color[2] = reader.readUint16();
            channel.color[3] = reader.readUint16();
            channel.opacity = reader.readUint16();
            channel.mode = reader.readByte();
          }
        }
        break;

      case ImageResource.globalAngle:
      case ImageResource.globalAltitude:
      case ImageResource.colorHalftoningInfo:
      case ImageResource.colorTransferFunctions:
      case ImageResource.multichannelHalftoningInfo:
      case ImageResource.multichannelTransferFunctions:
      case ImageResource.layerStateInformation:
      case ImageResource.layerGroupInformation:
      case ImageResource.layerGroupEnabledId:
      case ImageResource.layerSelectionId:
      case ImageResource.gridGuidesInfo:
      case ImageResource.urlList:
      case ImageResource.slices:
      case ImageResource.pixelAspectRatio:
      case ImageResource.iccUntaggedProfile:
      case ImageResource.idSeedNumber:
      case ImageResource.backgroundColor:
      case ImageResource.alphaChannelUnicodeNames:
      case ImageResource.alphaIdentifiers:
      case ImageResource.copyrightFlag:
      case ImageResource.pathSelectionState:
      case ImageResource.onionSkins:
      case ImageResource.timelineInfo:
      case ImageResource.sheetDisclosure:
      case ImageResource.workingPath:
      case ImageResource.macPrintManagerInfo:
      case ImageResource.windowsDevmode:
        // we are currently not interested in this resource, skip it
        reader.skip(resourceSize);
        break;

      case ImageResource.versionInfo:
        {
          // ignore: unused_local_variable
          final version = reader.readUint32();

          final hasRealMergedData = reader.readByte();
          imageResources.containsRealMergedData = (hasRealMergedData != 0);
          reader.skip(resourceSize - 5);
        }
        break;

      case ImageResource.thumbnailResource:
        {
          var thumbnail = Thumbnail();
          imageResources.thumbnail = thumbnail;

          // ignore: unused_local_variable
          final format = reader.readUint32();

          final width = reader.readUint32();
          final height = reader.readUint32();

          // ignore: unused_local_variable
          final widthInBytes = reader.readUint32();

          // ignore: unused_local_variable
          final totalSize = reader.readUint32();

          final binaryJpegSize = reader.readUint32();

          // ignore: unused_local_variable
          final bitsPerPixel = reader.readUint16();
          // ignore: unused_local_variable
          final numberOfPlanes = reader.readUint16();

          thumbnail.width = width;
          thumbnail.height = height;
          thumbnail.binaryJpegSize = binaryJpegSize;
          thumbnail.binaryJpeg = reader.readBytes(binaryJpegSize);

          final bytesToSkip = resourceSize - 28 - binaryJpegSize;
          reader.skip(bytesToSkip);
        }
        break;

      case ImageResource.xmpMetadata:
        {
          // load the XMP metadata as raw data
          assert(imageResources.xmpMetadata == null,
              'File contains more than one XMP metadata resource.');
          final xmpMetadata = reader.readBytes(resourceSize);
          if (xmpMetadata != null) {
            imageResources.xmpMetadata = String.fromCharCodes(xmpMetadata);
          }
        }
        break;

      case ImageResource.iccProfile:
        {
          // load the ICC profile as raw data
          assert(imageResources.iccProfile == null,
              'File contains more than one ICC profile.');
          imageResources.sizeOfICCProfile = resourceSize;
          imageResources.iccProfile = reader.readBytes(resourceSize);
        }
        break;

      case ImageResource.exifData:
        {
          // load the EXIF data as raw data
          assert(imageResources.exifData == null,
              'File contains more than one EXIF data block.');
          imageResources.sizeOfExifData = resourceSize;
          imageResources.exifData = reader.readBytes(resourceSize);
        }
        break;

      case ImageResource.alphaChannelAsciiNames:
        {
          // check whether storage for alpha channels has been allocated yet
          // (imageResource::DISPLAY_INFO stores the channel color data)
          if (imageResources.alphaChannels == null) {
            // note that this assumes RGB mode
            final channelCount = document.channelCount ?? 0 - 3;
            imageResources.alphaChannels =
                List<AlphaChannel>.filled(channelCount, AlphaChannel());
          }

          // the names of the alpha channels are stored as a series of Pascal strings
          var channel = 0;
          var remaining = resourceSize;
          while (remaining > 0) {
            String? channelName;
            final channelNameLength = reader.readByte();
            if (channelNameLength > 0) {
              var channelNameUint8List = reader.readBytes(channelNameLength);
              if (channelNameUint8List != null) {
                channelName = String.fromCharCodes(channelNameUint8List);
              }
            }

            remaining -= 1 + channelNameLength;

            if (channel < imageResources.alphaChannelCount) {
              imageResources.alphaChannels![channel].asciiName = channelName;
              ++channel;
            }
          }
        }
        break;

      default:
        // this is a resource we know nothing about, so skip it
        reader.skip(resourceSize);
        break;
    }
    leftToRead -= 10 + paddedNameLength + resourceSize;
  }
  return imageResources;
}
