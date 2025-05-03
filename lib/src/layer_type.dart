/// An enumeration representing the different types of layers in a Photoshop document.
///
/// This enum defines the various types of layers that can exist in a Photoshop
/// document, including regular layers, folder layers, and special divider layers.
/// Each type has specific characteristics and behaviors in the Photoshop UI
/// and affects how the layer is processed and displayed.
///
/// The enum values correspond to the internal type identifiers used in the
/// PSD file format, making it easier to work with layer type information
/// when reading or writing PSD files.
///
/// Example usage:
/// ```dart
/// final layer = Layer(document);
/// layer.type = LayerType.openFolder;
///
/// // Check layer type
/// if (layer.type == LayerType.sectionDivider) {
///   print('This is a section divider layer');
/// }
/// ```
enum LayerType {
  /// Represents any other type of layer not specifically categorized.
  ///
  /// This is the default type for regular image layers, adjustment layers,
  /// and other layer types that don't fall into the other specific categories.
  /// Layers of this type are fully visible in the Photoshop UI and can contain
  /// image data, masks, and other layer properties.
  any(0),

  /// Represents an open folder layer.
  ///
  /// Folder layers are used to organize other layers in the layer stack.
  /// An open folder is expanded in the Photoshop UI, showing all layers
  /// contained within it. This type is used when the folder is currently
  /// visible and accessible to the user.
  openFolder(1),

  /// Represents a closed folder layer.
  ///
  /// Similar to [openFolder], but indicates that the folder is collapsed
  /// in the Photoshop UI. The layers within the folder are still present
  /// but are not immediately visible in the layer stack.
  closedFolder(2),

  /// Represents a bounding section divider layer.
  ///
  /// This special type of layer is used to mark the boundaries of layer
  /// groups or sections in the document. These layers are typically hidden
  /// in the Photoshop UI and serve as organizational markers rather than
  /// containing visible content.
  sectionDivider(3);

  /// Creates a new [LayerType] instance with the specified [value].
  ///
  /// The [value] parameter corresponds to the internal type identifier
  /// used in the PSD file format.
  const LayerType(this.value);

  /// The integer value associated with this layer type in the PSD file format.
  ///
  /// This value is used when reading from or writing to PSD files to
  /// identify the type of layer being processed.
  final int value;
}
