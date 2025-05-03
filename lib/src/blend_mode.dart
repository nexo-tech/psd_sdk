import 'package:psd_sdk/src/key.dart';

enum BlendMode {
  /// Key = "pass"
  passThrough,

  /// Key = "norm"
  normal,

  /// Key = "diss"
  dissolve,

  /// Key = "dark"
  darken,

  /// Key = "mul "
  multiply,

  /// Key = "idiv"
  colorBurn,

  /// Key = "lbrn"
  linearBurn,

  /// Key = "dkCl"
  darkerColor,

  /// Key = "lite"
  lighten,

  /// Key = "scrn"
  screen,

  /// Key = "div "
  colorDodge,

  /// Key = "lddg"
  linearDodge,

  /// Key = "lgCl"
  lighterColor,

  /// Key = "over"
  overlay,

  /// Key = "sLit"
  softLight,

  /// Key = "hLit"
  hardLight,

  /// Key = "vLit"
  vividLight,

  /// Key = "lLit"
  linearLight,

  /// Key = "pLit"
  pinLight,

  /// Key = "hMix"
  hardMix,

  /// Key = "diff"
  difference,

  /// Key = "smud"
  exclusion,

  /// Key = "fsub"
  subtract,

  /// Key = "fdiv"
  divide,

  /// Key = "hue "
  hue,

  /// Key = "sat "
  saturation,

  /// Key = "colr"
  color,

  /// Key = "lum "
  luminosity,

  unknown
}

/// Converts a given key to the corresponding BlendMode.
BlendMode blendModeKeyToEnum(int key) {
  if (key == keyValue('pass')) {
    return BlendMode.passThrough;
  } else if (key == keyValue('norm')) {
    return BlendMode.normal;
  } else if (key == keyValue('diss')) {
    return BlendMode.dissolve;
  } else if (key == keyValue('dark')) {
    return BlendMode.darken;
  } else if (key == keyValue('mul ')) {
    return BlendMode.multiply;
  } else if (key == keyValue('idiv')) {
    return BlendMode.colorBurn;
  } else if (key == keyValue('lbrn')) {
    return BlendMode.linearBurn;
  } else if (key == keyValue('dkCl')) {
    return BlendMode.darkerColor;
  } else if (key == keyValue('lite')) {
    return BlendMode.lighten;
  } else if (key == keyValue('scrn')) {
    return BlendMode.screen;
  } else if (key == keyValue('div ')) {
    return BlendMode.colorDodge;
  } else if (key == keyValue('lddg')) {
    return BlendMode.linearDodge;
  } else if (key == keyValue('lgCl')) {
    return BlendMode.lighterColor;
  } else if (key == keyValue('over')) {
    return BlendMode.overlay;
  } else if (key == keyValue('sLit')) {
    return BlendMode.softLight;
  } else if (key == keyValue('hLit')) {
    return BlendMode.hardLight;
  } else if (key == keyValue('vLit')) {
    return BlendMode.vividLight;
  } else if (key == keyValue('lLit')) {
    return BlendMode.linearLight;
  } else if (key == keyValue('pLit')) {
    return BlendMode.pinLight;
  } else if (key == keyValue('hMix')) {
    return BlendMode.hardMix;
  } else if (key == keyValue('diff')) {
    return BlendMode.difference;
  } else if (key == keyValue('smud')) {
    return BlendMode.exclusion;
  } else if (key == keyValue('fsub')) {
    return BlendMode.subtract;
  } else if (key == keyValue('fdiv')) {
    return BlendMode.divide;
  } else if (key == keyValue('hue ')) {
    return BlendMode.hue;
  } else if (key == keyValue('sat ')) {
    return BlendMode.saturation;
  } else if (key == keyValue('colr')) {
    return BlendMode.color;
  } else if (key == keyValue('lum ')) {
    return BlendMode.luminosity;
  }
  return BlendMode.unknown;
}
