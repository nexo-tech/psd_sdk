enum ImageResource {
  iptcNaa(1028),
  captionDigest(1061),
  xmpMetadata(1060),
  printInformation(1082),
  printStyle(1083),
  printScale(1062),
  printFlags(1011),
  printFlagsInfo(10000),
  printInfo(1071),
  resolutionInfo(1005),
  displayInfo(1077),
  globalAngle(1037),
  globalAltitude(1049),
  colorHalftoningInfo(1013),
  colorTransferFunctions(1016),
  multichannelHalftoningInfo(1012),
  multichannelTransferFunctions(1015),
  layerStateInformation(1024),
  layerGroupInformation(1026),
  layerGroupEnabledId(1072),
  layerSelectionId(1069),
  gridGuidesInfo(1032),
  urlList(1054),
  slices(1050),
  pixelAspectRatio(1064),
  iccProfile(1039),
  iccUntaggedProfile(1041),
  idSeedNumber(1044),
  thumbnailResource(1036),
  versionInfo(1057),
  exifData(1058),
  backgroundColor(1010),
  alphaChannelAsciiNames(1006),
  alphaChannelUnicodeNames(1045),
  alphaIdentifiers(1053),
  copyrightFlag(1034),
  pathSelectionState(1088),
  onionSkins(1078),
  timelineInfo(1075),
  sheetDisclosure(1076),
  workingPath(1025),
  macPrintManagerInfo(1001),
  windowsDevmode(1085);

  const ImageResource(this.value);
  final int value;

  static ImageResource? fromValue(int value) {
    try {
      return ImageResource.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}
