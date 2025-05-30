# psd_sdk

[![pub package](https://img.shields.io/badge/pub-0.2.1-blueviolet.svg)](https://pub.dev/packages/psd_sdk)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)
[![License: BSD-3-Clause](https://img.shields.io/badge/License-BSD--3--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)

A Dart library for reading and manipulating Photoshop PSD files. This library is a Dart port of the original [psd_sdk](https://github.com/MolecularMatters/psd_sdk) by [Molecular Matters](https://molecular-matters.com/).

## Features

### Reading Capabilities
- ✅ Full support for PSD file structure
- ✅ Layer groups and nested layers
- ✅ Smart Objects
- ✅ User and vector masks
- ✅ Transparency masks and additional alpha channels
- ✅ Support for 8-bit, 16-bit, and 32-bit data
- ✅ Grayscale and RGB color modes
- ✅ All Photoshop compression types (RAW, RLE, ZIP, ZIP with prediction)

### Export Capabilities
- ✅ Basic export functionality
- ✅ Layer data extraction
- ✅ Channel data access
- ✅ Mask data retrieval

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  psd_sdk: ^0.2.1
```

Then run:
```bash
dart pub get
```

## Usage

### Reading a PSD File

```dart
import 'dart:io';
import 'package:psd_sdk/psd_sdk.dart';

void main() async {
  // Load a PSD file
  final file = File.fromByteData(File('path/to/your/file.psd').readAsBytesSync());
  final document = Document.fromFile(file);

  // Access document properties
  print('Width: ${document.width}');
  print('Height: ${document.height}');
  print('Color Mode: ${document.colorMode}');
  print('Bits per Channel: ${document.bitsPerChannel}');

  // Parse and access layers
  final layerMaskSection = document.parseLayerMaskSection(file);
  for (final layer in layerMaskSection?.layers ?? []) {
    layer.extract(file);
    print('Layer: ${layer.name}');
    print('Visible: ${layer.visible}');
    print('Opacity: ${layer.opacity}');
  }
}
```

### Writing a PSD File

```dart
import 'dart:io';
import 'package:psd_sdk/psd_sdk.dart';

void main() async {
  // Create a new PSD document
  final document = ExportDocument(
    800,  // width
    600,  // height
    8,    // bits per channel
    ExportColorMode.rgb  // color mode
  );

  // Add a layer
  final layer = document.addLayer(document, 'My Layer');
  
  // Create some sample data
  final data = Uint8List(800 * 600);
  for (var i = 0; i < data.length; i++) {
    data[i] = (i % 255).toInt();
  }

  // Update layer with data
  document.updateLayer(
    layer!,
    ExportChannel.red,
    0, 0, 800, 600,  // x, y, width, height
    data,
    CompressionType.raw
  );

  // Write to file
  final file = File();
  document.write(file);
  File('output.psd').writeAsBytesSync(file.bytes!);
}
```

## API Reference

### Core Classes

- `File`: Base class for handling binary file data
- `Document`: Main class for PSD file operations and parsing
- `ExportDocument`: Class for creating and exporting PSD files
- `Layer`: Represents a PSD layer with properties and data
- `LayerRect`: Interface for layer and mask dimensions
- `LayerMaskSection`: Container for layer and mask information
- `Channel`: Represents a channel in a Photoshop layer
- `AlphaChannel`: Represents an alpha channel with color and opacity information
- `Mask`: Base class for layer masks
- `LayerMask`: Represents a layer mask
- `VectorMask`: Represents a vector mask

### Utility Classes

- `ImageUtil`: Utility class for handling image data operations
- `Section`: Base class for PSD file sections

### Enums

- `ColorMode`: Document color modes (Bitmap, Grayscale, RGB, etc.)
- `ChannelType`: Channel data types
- `LayerType`: Layer types
- `ExportColorMode`: Export color modes (Grayscale, RGB)
- `ExportChannel`: Export channel types (Gray, Red, Green, Blue, Alpha)
- `CompressionType`: Data compression types (Raw, RLE, ZIP, ZIP with prediction)
- `BlendMode`: Layer blend modes (Normal, Multiply, Screen, etc.)
- `AlphaChannelMode`: Alpha channel modes

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the BSD-3-Clause License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Original C++ implementation by [Molecular Matters](https://molecular-matters.com/)
- Dart port and maintenance by [nexo tech](https://github.com/nexo-tech)

## Support

For support, please open an issue in the [GitHub repository](https://github.com/nexo-tech/psd_sdk).
