import 'dart:typed_data';

import 'channel_type.dart';

/// A class representing a channel in a Photoshop layer.
///
/// This class encapsulates the data and metadata for a single channel within
/// a Photoshop layer. Channels can represent different types of information:
///
/// - Color channels (R, G, B)
/// - Transparency masks
/// - Layer masks
/// - Vector masks
///
/// The class provides access to:
/// - Channel data and its size
/// - File offset information for reading/writing
/// - Channel type identification
/// - Layer-specific indexing
///
/// Example usage:
/// ```dart
/// final channel = Channel(0); // Create a channel at index 0
/// channel.type = ChannelType.r; // Set as red channel
/// channel.data = Uint8List(800 * 600); // Allocate data buffer
/// ```
class Channel {
  /// Creates a new [Channel] instance with the specified [index].
  ///
  /// The [index] parameter indicates the position of this channel within
  /// its parent layer's channel list. This index is used to maintain the
  /// correct order of channels when reading from or writing to PSD files.
  Channel(this.index);

  /// The index of this channel within its parent layer.
  ///
  /// This value represents the position of the channel in the layer's
  /// channel list. It is used to maintain the correct order of channels
  /// and to identify specific channels within a layer.
  final int index;

  /// The file offset where this channel's data is stored in the PSD file.
  ///
  /// This value represents the byte offset from the start of the PSD file
  /// where this channel's data begins. It is used when reading channel data
  /// from the file or when writing channel data back to the file.
  ///
  /// A null value indicates that the file offset has not been set or that
  /// the channel's data is not stored in the file.
  int? fileOffset;

  /// The size of the channel's data in bytes.
  ///
  /// This value represents the number of bytes that need to be read from
  /// the file to obtain the complete channel data. It is used in conjunction
  /// with [fileOffset] to read the correct amount of data from the file.
  ///
  /// A null value indicates that the size has not been determined or that
  /// the channel has no data.
  int? size;

  /// The planar data for this channel.
  ///
  /// This property contains the actual channel data in planar format. The
  /// size of the data should match the dimensions of the parent layer
  /// (width * height bytes). The data is only considered valid if the
  /// [type] property indicates a valid channel type.
  ///
  /// The data is stored as a [Uint8List], where each byte represents a
  /// single pixel value in the channel. For color channels, this typically
  /// represents the intensity of the color component (R, G, or B).
  ///
  /// A null value indicates that no data has been loaded or allocated for
  /// this channel.
  Uint8List? data;

  /// The type of this channel.
  ///
  /// This property identifies what kind of data the channel contains. It can
  /// be one of the values from the [ChannelType] enum, such as:
  /// - Color channels (R, G, B)
  /// - Transparency masks
  /// - Layer masks
  /// - Vector masks
  ///
  /// The type determines how the channel's data should be interpreted and
  /// processed. A null value indicates that the channel type has not been
  /// set or is unknown.
  ChannelType? type;
}
