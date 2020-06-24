{ lib, mkFont, fetchurl }:

mkFont {
  pname = "mro-unicode";
  version = "2013-05-25";

  src = fetchurl {
    url = "https://github.com/phjamr/MroUnicode/raw/f297de070f7eba721a47c850e08efc119d3bfbe8/MroUnicode-Regular.ttf";
    sha256 = "1za74ych0sh97ks6qp9iqq9jankgnkrq65s350wsbianwi72di45";
  };

  noUnpackFonts = true;

  meta = with lib; {
    homepage = "https://github.com/phjamr/MroUnicode";
    description = "Unicode-compliant Mro font";
    maintainers = with maintainers; [ mathnerd314 ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
