import 'package:psd_sdk/src/key.dart';

/// An enumeration representing the blend modes supported by Photoshop for layer compositing.
///
/// Blend modes determine how the pixels of a layer interact with the pixels of layers
/// below it. Each blend mode uses a different mathematical formula to combine the
/// colors and create various visual effects.
///
/// The blend mode is specified in the layer's blend mode key and affects how the
/// layer's content is composited with the layers below it. Understanding blend modes
/// is essential for creating complex visual effects and achieving desired compositing
/// results.
///
/// Example usage:
/// ```dart
/// // Set a layer's blend mode to Multiply
/// final blendMode = BlendMode.multiply;
///
/// // Convert a blend mode key to an enum value
/// final key = keyValue('mul ');
/// final mode = blendModeKeyToEnum(key);
/// print(mode); // BlendMode.multiply
/// ```
enum BlendMode {
  /// Pass Through blend mode.
  ///
  /// This blend mode allows the layer to pass through to the group below it,
  /// effectively ignoring the group's blend mode. It is typically used for
  /// adjustment layers within a group.
  ///
  /// Key: "pass"
  passThrough,

  /// Normal blend mode.
  ///
  /// This is the default blend mode where the layer's pixels completely replace
  /// the pixels below it, with opacity determining the degree of replacement.
  ///
  /// Key: "norm"
  normal,

  /// Dissolve blend mode.
  ///
  /// This blend mode randomly replaces some pixels with the layer's color,
  /// creating a scattered or noise-like effect. The effect becomes more
  /// pronounced with lower opacity.
  ///
  /// Key: "diss"
  dissolve,

  /// Darken blend mode.
  ///
  /// This blend mode compares the color components of the layer and the
  /// underlying layers, keeping the darker values. It's useful for darkening
  /// images or creating shadow effects.
  ///
  /// Key: "dark"
  darken,

  /// Multiply blend mode.
  ///
  /// This blend mode multiplies the color values of the layer with the
  /// underlying layers, resulting in a darker image. It's commonly used
  /// for creating shadows or darkening effects.
  ///
  /// Key: "mul "
  multiply,

  /// Color Burn blend mode.
  ///
  /// This blend mode darkens the underlying layers by increasing the contrast
  /// and saturating the colors. It creates a strong darkening effect with
  /// increased color intensity.
  ///
  /// Key: "idiv"
  colorBurn,

  /// Linear Burn blend mode.
  ///
  /// This blend mode darkens the underlying layers by decreasing the brightness.
  /// It produces a more linear darkening effect compared to Color Burn.
  ///
  /// Key: "lbrn"
  linearBurn,

  /// Darker Color blend mode.
  ///
  /// This blend mode compares the total brightness of the layer and underlying
  /// layers, keeping the darker color. It's similar to Darken but works on the
  /// overall color rather than individual channels.
  ///
  /// Key: "dkCl"
  darkerColor,

  /// Lighten blend mode.
  ///
  /// This blend mode compares the color components of the layer and the
  /// underlying layers, keeping the lighter values. It's useful for lightening
  /// images or creating highlight effects.
  ///
  /// Key: "lite"
  lighten,

  /// Screen blend mode.
  ///
  /// This blend mode multiplies the inverse of the layer's colors with the
  /// inverse of the underlying colors, resulting in a lighter image. It's
  /// commonly used for creating glow effects or lightening images.
  ///
  /// Key: "scrn"
  screen,

  /// Color Dodge blend mode.
  ///
  /// This blend mode brightens the underlying layers by decreasing the contrast
  /// and increasing the brightness. It creates a strong lightening effect with
  /// increased color intensity.
  ///
  /// Key: "div "
  colorDodge,

  /// Linear Dodge blend mode.
  ///
  /// This blend mode brightens the underlying layers by increasing the brightness.
  /// It produces a more linear lightening effect compared to Color Dodge.
  ///
  /// Key: "lddg"
  linearDodge,

  /// Lighter Color blend mode.
  ///
  /// This blend mode compares the total brightness of the layer and underlying
  /// layers, keeping the lighter color. It's similar to Lighten but works on the
  /// overall color rather than individual channels.
  ///
  /// Key: "lgCl"
  lighterColor,

  /// Overlay blend mode.
  ///
  /// This blend mode combines Multiply and Screen blend modes. It darkens or
  /// lightens the underlying layers depending on the layer's color, preserving
  /// highlights and shadows.
  ///
  /// Key: "over"
  overlay,

  /// Soft Light blend mode.
  ///
  /// This blend mode applies a subtle lighting effect, similar to shining a
  /// diffused spotlight on the image. It's useful for creating gentle lighting
  /// effects or enhancing contrast.
  ///
  /// Key: "sLit"
  softLight,

  /// Hard Light blend mode.
  ///
  /// This blend mode combines Multiply and Screen blend modes, but with more
  /// intensity than Overlay. It creates strong lighting effects and can be used
  /// for dramatic image adjustments.
  ///
  /// Key: "hLit"
  hardLight,

  /// Vivid Light blend mode.
  ///
  /// This blend mode combines Color Burn and Color Dodge blend modes, creating
  /// intense color effects. It's useful for creating dramatic color adjustments
  /// and special effects.
  ///
  /// Key: "vLit"
  vividLight,

  /// Linear Light blend mode.
  ///
  /// This blend mode combines Linear Burn and Linear Dodge blend modes. It
  /// creates strong lighting effects with a more linear response than Vivid Light.
  ///
  /// Key: "lLit"
  linearLight,

  /// Pin Light blend mode.
  ///
  /// This blend mode replaces colors based on the layer's brightness. It's
  /// useful for creating special effects and color adjustments.
  ///
  /// Key: "pLit"
  pinLight,

  /// Hard Mix blend mode.
  ///
  /// This blend mode creates a posterized effect by reducing the number of
  /// colors. It's useful for creating stylized images or special effects.
  ///
  /// Key: "hMix"
  hardMix,

  /// Difference blend mode.
  ///
  /// This blend mode subtracts the layer's color from the underlying colors or
  /// vice versa, depending on which has the greater brightness value. It's
  /// useful for creating inversion effects.
  ///
  /// Key: "diff"
  difference,

  /// Exclusion blend mode.
  ///
  /// This blend mode creates an effect similar to Difference but with lower
  /// contrast. It's useful for creating subtle color effects and special
  /// effects.
  ///
  /// Key: "smud"
  exclusion,

  /// Subtract blend mode.
  ///
  /// This blend mode subtracts the layer's color from the underlying colors.
  /// It's useful for creating darkening effects and special effects.
  ///
  /// Key: "fsub"
  subtract,

  /// Divide blend mode.
  ///
  /// This blend mode divides the underlying colors by the layer's color.
  /// It's useful for creating lightening effects and special effects.
  ///
  /// Key: "fdiv"
  divide,

  /// Hue blend mode.
  ///
  /// This blend mode preserves the luminance and saturation of the underlying
  /// colors while applying the hue of the layer. It's useful for colorizing
  /// images.
  ///
  /// Key: "hue "
  hue,

  /// Saturation blend mode.
  ///
  /// This blend mode preserves the luminance and hue of the underlying colors
  /// while applying the saturation of the layer. It's useful for adjusting
  /// color intensity.
  ///
  /// Key: "sat "
  saturation,

  /// Color blend mode.
  ///
  /// This blend mode preserves the luminance of the underlying colors while
  /// applying the hue and saturation of the layer. It's useful for colorizing
  /// images while preserving brightness.
  ///
  /// Key: "colr"
  color,

  /// Luminosity blend mode.
  ///
  /// This blend mode preserves the hue and saturation of the underlying colors
  /// while applying the luminance of the layer. It's useful for adjusting
  /// brightness while preserving color.
  ///
  /// Key: "lum "
  luminosity,

  /// Unknown blend mode.
  ///
  /// This value is returned when the blend mode key does not match any known
  /// blend mode. It indicates that the blend mode is either unsupported or
  /// invalid.
  unknown
}

/// Converts a blend mode key to its corresponding [BlendMode] enum value.
///
/// This function maps the four-character key used in PSD files to represent
/// blend modes to their corresponding enum values. The key is typically stored
/// in the layer's blend mode field.
///
/// Parameters:
/// - [key]: The blend mode key to convert (e.g., keyValue('mul ') for Multiply)
///
/// Returns:
/// The corresponding [BlendMode] enum value, or [BlendMode.unknown] if the key
/// does not match any known blend mode.
///
/// Example:
/// ```dart
/// final key = keyValue('mul ');
/// final mode = blendModeKeyToEnum(key);
/// print(mode); // BlendMode.multiply
///
/// final unknownKey = keyValue('xxxx');
/// final unknownMode = blendModeKeyToEnum(unknownKey);
/// print(unknownMode); // BlendMode.unknown
/// ```
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
