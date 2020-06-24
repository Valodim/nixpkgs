{ lib, mkFont, fetchFromGitHub }:

mkFont rec {
  pname = "merriweather";
  version = "2.005";

  src = fetchFromGitHub {
    owner = "SorkinType";
    repo = "Merriweather";
    rev = "4fd88c9299009d1c1d201e7da3ff75cf1de5153a";
    sha256 = "1ndycja2jzhcfbqbm0p6ka2zl1i1pdbkf0crw2lp3pi4k89wlm29";
  };

  # TODO: it would be nice to build this from scratch, but lots of
  # Python dependencies to package (fontmake, gftools)

  meta = with lib; {
    homepage = "https://github.com/SorkinType/Merriweather";
    description = "Merriweather was designed to be a text face that is pleasant to read on screens";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ emily ];
  };
}
