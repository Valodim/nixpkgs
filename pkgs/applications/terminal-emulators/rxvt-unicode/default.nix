{ lib, stdenv, fetchurl, makeDesktopItem
, libX11, libXt, libXft, libXrender
, ncurses, fontconfig, freetype
, pkg-config, gdk-pixbuf, perl
, libptytty
, perlSupport      ? true
, gdkPixbufSupport ? true
, unicode3Support  ? true
, emojiSupport     ? false
}:

let
  pname = "rxvt-unicode";
  version = "9.30";
  description = "A clone of the well-known terminal emulator rxvt";

  desktopItem = makeDesktopItem {
    name = pname;
    exec = "urxvt";
    icon = "utilities-terminal";
    comment = description;
    desktopName = "URxvt";
    genericName = pname;
    categories = "System;TerminalEmulator;";
  };
in

with lib;

stdenv.mkDerivation {
  name = "${pname}-unwrapped-${version}";
  inherit pname version;

  src = fetchurl {
    url = "http://dist.schmorp.de/rxvt-unicode/Attic/rxvt-unicode-${version}.tar.bz2";
    sha256 = "0badnkjsn3zps24r5iggj8k5v4f00npc77wqg92pcn1q5z8r677y";
  };

  buildInputs =
    [ libX11 libXt libXft ncurses  # required to build the terminfo file
      fontconfig freetype pkg-config libXrender
      libptytty
    ] ++ optional perlSupport perl
      ++ optional gdkPixbufSupport gdk-pixbuf;

  outputs = [ "out" "terminfo" ];

  patches = (if emojiSupport then [
    # wide glyph feature for emoji support, from AUR package by mrdotx
    # https://aur.archlinux.org/packages/rxvt-unicode-truecolor-wide-glyphs/
    # the required patches to libXft are applied by default, see
    # ../../../servers/x11/xorg/overrides.nix
    ./patches/enable-wide-glyphs.patch
    ./patches/improve-font-rendering.patch
  ] else [
    ./patches/9.06-font-width.patch
  ]) ++ [
    ./patches/256-color-resources.patch
  ]++ optional stdenv.isDarwin ./patches/makefile-phony.patch;

  configureFlags = [
    "--with-terminfo=${placeholder "terminfo"}/share/terminfo"
    "--enable-256-color"
    (enableFeature perlSupport "perl")
    (enableFeature unicode3Support "unicode3")
  ] ++ optional emojiSupport "--enable-wide-glyphs";

  LDFLAGS = [ "-lfontconfig" "-lXrender" "-lpthread" ];
  CFLAGS = [ "-I${freetype.dev}/include/freetype2" ];

  preConfigure =
    ''
      # without this the terminfo won't be compiled by tic, see man tic
      mkdir -p $terminfo/share/terminfo
      export TERMINFO=$terminfo/share/terminfo
    ''
    + lib.optionalString perlSupport ''
      # make urxvt find its perl file lib/perl5/site_perl
      # is added to PERL5LIB automatically
      mkdir -p $out/$(dirname ${perl.libPrefix})
      ln -s $out/lib/urxvt $out/${perl.libPrefix}
    '';

  postInstall = ''
    mkdir -p $out/nix-support
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
    cp -r ${desktopItem}/share/applications/ $out/share/
  '';

  meta = {
    inherit description;
    homepage = "http://software.schmorp.de/pkg/rxvt-unicode.html";
    downloadPage = "http://dist.schmorp.de/rxvt-unicode/Attic/";
    maintainers = with maintainers; [ rnhmjoj ];
    platforms = platforms.unix;
    license = licenses.gpl3;
  };
}
