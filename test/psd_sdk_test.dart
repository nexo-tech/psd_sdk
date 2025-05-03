import 'dart:typed_data';
import 'dart:io' as io;

import 'package:psd_sdk/psd_sdk.dart';
import 'package:psd_sdk/src/image_data_section.dart';
import '../example/psd_sdk_example.dart';
import 'package:test/test.dart';

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
    if (document.colorMode != ColorMode.rgb) {
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

      final isNotLoaded =
          layer?.channels?.every((channel) => channel?.data == null) ?? false;

      if (!isNotLoaded) {
        return;
      }

      extractLayer(document, file, layer!);

      final indexR = findChannel(layer!, ChannelType.r);
      final indexG = findChannel(layer!, ChannelType.g);
      final indexB = findChannel(layer!, ChannelType.b);
      final indexA = findChannel(layer!, ChannelType.transparencyMask);

      canvasData = List<Uint8List?>.filled(4, null);
      channelCount = 0;

      if (indexR != channelNotFound &&
          indexG != channelNotFound &&
          indexB != channelNotFound) {
        canvasData[0] =
            expandChannelToCanvas(document, layer!, layer!.channels![indexR!]!);
        canvasData[1] =
            expandChannelToCanvas(document, layer!, layer!.channels![indexG!]!);
        canvasData[2] =
            expandChannelToCanvas(document, layer!, layer!.channels![indexB!]!);
        channelCount = 3;

        if (indexA != channelNotFound) {
          canvasData[3] = expandChannelToCanvas(
              document, layer!, layer!.channels![indexA!]!);
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
    });

    test('should have correct channel indices', () {
      final indexR = findChannel(layer!, ChannelType.r);
      final indexG = findChannel(layer!, ChannelType.g);
      final indexB = findChannel(layer!, ChannelType.b);
      final indexA = findChannel(layer!, ChannelType.transparencyMask);

      expect(indexR, 1);
      expect(indexG, 2);
      expect(indexB, 3);
      expect(indexA, 0);
    });

    test('canvas data 0', () {
      // test cavnas data 0
      expect(canvasData[0]![0], 102);
      expect(canvasData[0]![20971], 255);
      expect(canvasData[0]![41942], 0);
      expect(canvasData[0]![62913], 255);
      expect(canvasData[0]![83884], 0);
      expect(canvasData[0]![104855], 255);
      expect(canvasData[0]![125826], 0);
    });

    test('canvas data 1', () {
      expect(canvasData[1]![0], 43);
      expect(canvasData[1]![1923], 0);
      expect(canvasData[1]![3846], 0);
      expect(canvasData[1]![5769], 0);
      expect(canvasData[1]![7692], 0);
      expect(canvasData[1]![9615], 255);
      expect(canvasData[1]![11538], 39);
      expect(canvasData[1]![13461], 44);
      expect(canvasData[1]![15384], 175);
    });

    test('canvas data 2', () {
      expect(canvasData[2]![0], 14);
      expect(canvasData[2]![1024], 9);
      expect(canvasData[2]![2048], 11);
      expect(canvasData[2]![3072], 14);
      expect(canvasData[2]![4096], 14);
      expect(canvasData[2]![5120], 16);
      expect(canvasData[2]![6144], 14);
      expect(canvasData[2]![7168], 13);

      expect(canvasData[2]![31744], 67);
      expect(canvasData[2]![32768], 67);
      expect(canvasData[2]![33792], 57);
    });

    test('canvas data 3', () {
      expect(canvasData[3]![0], 255);
      expect(canvasData[3]![1349], 255);
      expect(canvasData[3]![2698], 0);
      expect(canvasData[3]![4047], 0);
      expect(canvasData[3]![5396], 255);
      expect(canvasData[3]![6745], 0);
      expect(canvasData[3]![8094], 0);
      expect(canvasData[3]![9443], 255);
      expect(canvasData[3]![10792], 0);
      expect(canvasData[3]![12141], 0);
      expect(canvasData[3]![13490], 255);
      expect(canvasData[3]![14839], 0);
      expect(canvasData[3]![16188], 0);
      expect(canvasData[3]![17537], 255);
    });

    test('image8', () {
      expect(interleavedImage![0], 102);
      expect(interleavedImage![1], 43);
      expect(interleavedImage![2], 14);
      expect(interleavedImage![3], 255);
      expect(interleavedImage![4], 128);
      expect(interleavedImage![5], 65);
      expect(interleavedImage![6], 35);
      expect(interleavedImage![7], 255);

      expect(interleavedImage![496974], 53);
      expect(interleavedImage![497313], 255);
      expect(interleavedImage![497652], 255);
      expect(interleavedImage![497991], 0);
      expect(interleavedImage![498330], 0);
      expect(interleavedImage![498669], 0);
      expect(interleavedImage![499008], 0);
      expect(interleavedImage![499347], 0);
      expect(interleavedImage![499686], 0);
    });
  });
}
