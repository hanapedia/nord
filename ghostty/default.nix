# Renders ghostty theme files (plain `key = value` text, confirmed against
# /usr/share/ghostty/themes/Nord on the target machine).
# Output: $out/share/ghostty/themes/{nord-dark,nord-light}
{ pkgs, palette, nordLib }:
let
  render = nordLib.render;

  cursorFg = base: base.bg;
  cursorBg = base: base.fg_light;
  selectionBg = base: base.selection;
  selectionFg = base: base.fg;

  renderTheme = base:
    let
      ansi = nordLib.ansi base;
      paletteRows = map (n: { key = "palette"; value = "${n}=${ansi.${n}}"; }) (
        map toString (builtins.genList (i: i) 16)
      );
      rows = paletteRows ++ [
        { key = "background"; value = base.bg; }
        { key = "foreground"; value = base.fg; }
        { key = "cursor-color"; value = cursorBg base; }
        { key = "cursor-text"; value = cursorFg base; }
        { key = "selection-background"; value = selectionBg base; }
        { key = "selection-foreground"; value = selectionFg base; }
      ];
    in
    render.toKeyValue rows;

  dark = renderTheme (render.assertHexPalette palette.dark);
  light = renderTheme (render.assertHexPalette palette.light);
in
pkgs.runCommand "nord-ghostty-themes"
  {
    darkTheme = dark;
    lightTheme = light;
    passAsFile = [ "darkTheme" "lightTheme" ];
  } ''
  mkdir -p "$out/share/ghostty/themes"
  cp "$darkThemePath" "$out/share/ghostty/themes/nord-dark"
  cp "$lightThemePath" "$out/share/ghostty/themes/nord-light"
''
