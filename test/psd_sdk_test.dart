import 'dart:typed_data';
import 'dart:io' as io;

import 'package:psd_sdk/psd_sdk.dart';
import 'package:psd_sdk/src/image_data_section.dart';
import '../example/psd_sdk_example.dart';
import 'package:test/test.dart';
import 'canvas_data_test.dart';

const int channelNotFound = -1;

void main() {
  late Document document;
  late File file;
  late LayerMaskSection? layerMaskSection;
  late Layer? layer;
  late ImageDataSection? imageData;
  late bool isRgb;
  late Uint8List? image;
  late Uint8List? image8;
  late Uint8List? image16;
  late Uint8List? image32;

  setUpAll(() {
    final srcPath = '${getSampleInputPath()}Sample.psd';
    file = File();
    try {
      file.setByteData(io.File(srcPath).readAsBytesSync());
    } catch (e) {
      throw Exception('Cannot open file.');
    }

    document = createDocument(file)!;
    if (document.colorMode != ColorMode.RGB) {
      throw Exception('Document is not in RGB color mode.');
    }

    layerMaskSection = parseLayerMaskSection(document, file);
    layer = layerMaskSection!.layers?[0];
    imageData = parseImageDataSection(document, file);

    // Determine if image is RGB or RGBA
    final imageCount = imageData?.imageCount;
    final hasTransparencyMask = layerMaskSection?.hasTransparencyMask;

    if (imageCount == 3) {
      isRgb = true;
    } else if ((imageCount ?? 0) >= 4) {
      isRgb = !(hasTransparencyMask ?? false);
    } else {
      isRgb = false;
    }

    // Create interleaved image
    image = isRgb
        ? interleaveRGB(
            imageData?.images?[0]!.data,
            imageData?.images?[1]!.data,
            imageData?.images?[2]!.data,
            0,
            document.bitsPerChannel ?? 0,
            document.width ?? 0,
            document.height ?? 0)
        : interleaveRGBA(
            imageData?.images?[0]!.data,
            imageData?.images?[1]!.data,
            imageData?.images?[2]!.data,
            imageData?.images?[3]!.data,
            document.bitsPerChannel ?? 0,
            document.width ?? 0,
            document.height ?? 0);

    image8 = document.bitsPerChannel == 8 ? image : null;
    image16 = document.bitsPerChannel == 16 ? image : null;
    image32 = document.bitsPerChannel == 32 ? image : null;
  });

  group('Document Tests', () {
    test('should have correct document properties', () {
      expect(document.bitsPerChannel, 8);
      expect(document.width, 1024);
      expect(document.height, 1024);
    });

    test('should have correct layer properties', () {
      expect(layer?.name, 'UpperLeft');
      expect(layer?.channelCount, 4);
      expect(layer?.right, 512);
      expect(layer?.layerMask, null);
      expect(layer?.opacity, 255);
    });
  });

  group('Merged Image Tests', () {
    test('should have correct image type', () {
      expect(image8 != null, true);
      expect(image16, null);
      expect(image32, null);
    });

    test('should have correct image8 pixel values', () {
      expect(image8![0], 102);
      expect(image8![1], 43);
      expect(image8![2], 14);
      expect(image8![6], 35);
      expect(image8![7], 255);
      expect(image8![16], 201);
      expect(image8![17], 82);
      expect(image8![21], 81);
      expect(image8![22], 24);
      expect(image8![49], 80);
    });
  });

  group('Canvas Data Tests', () {
    late List<Uint8List?> canvasData;
    late Uint8List? interleavedImage;
    late int channelCount;

    setUp(() {
      if (layer == null) throw Exception('Layer is null');
      extractLayer(document, file, layer!);

      final indexR = findChannel(layer!, ChannelType.R);
      final indexG = findChannel(layer!, ChannelType.G);
      final indexB = findChannel(layer!, ChannelType.B);
      final indexA = findChannel(layer!, ChannelType.TRANSPARENCY_MASK);

      canvasData = List<Uint8List?>.filled(4, null);
      channelCount = 0;

      if (indexR != channelNotFound &&
          indexG != channelNotFound &&
          indexB != channelNotFound) {
        canvasData[0] =
            expandChannelToCanvas(document, layer!, layer!.channels![indexR]!);
        canvasData[1] =
            expandChannelToCanvas(document, layer!, layer!.channels![indexG]!);
        canvasData[2] =
            expandChannelToCanvas(document, layer!, layer!.channels![indexB]!);
        channelCount = 3;

        if (indexA != channelNotFound) {
          canvasData[3] = expandChannelToCanvas(
              document, layer!, layer!.channels![indexA]!);
          channelCount = 4;
        }
      }

      interleavedImage = channelCount == 3
          ? interleaveRGB(
              canvasData[0]!,
              canvasData[1]!,
              canvasData[2]!,
              document.bitsPerChannel ?? 0,
              0,
              document.width ?? 0,
              document.height ?? 0)
          : interleaveRGBA(
              canvasData[0]!,
              canvasData[1]!,
              canvasData[2]!,
              canvasData[3]!,
              document.bitsPerChannel ?? 0,
              document.width ?? 0,
              document.height ?? 0);

      test('should have correct channel indices', () {
        expect(indexR, 1);
        expect(indexG, 2);
        expect(indexB, 3);
        expect(indexA, 0);
      });
    });

    test('canvas data should match expected values', () {
      canvasDataTest(canvasData, interleavedImage!);
    });
  });
}
