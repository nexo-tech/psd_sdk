enum LayerType {
  /// Any other type of layer.
  any(0),

  /// Open folder.
  openFolder(1),

  /// Closed folder.
  closedFolder(2),

  /// Bounding section divider, hidden in the UI.
  sectionDivider(3);

  const LayerType(this.value);
  final int value;
}
