{ lib, mkFont, fetchFromGitHub, autoreconfHook, fontforge }:

mkFont rec {
  pname = "tlwg";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "tlwg";
    repo = "fonts-tlwg";
    rev = "v${version}";
    sha256 = "13bx98ygyyizb15ybdv3856lkxhx1fss8f7aiqmp0lk9zgw4mqyk";
  };

  nativeBuildInputs = [ autoreconfHook fontforge ];

  dontBuild = false;
  dontConfigure = false;
  preAutoreconf = "echo ${version} > VERSION";

  meta = with lib; {
    description = "A collection of Thai scalable fonts available under free licenses";
    homepage = "https://linux.thai.net/projects/fonts-tlwg";
    license = with licenses; [ gpl2 publicDomain lppl13c free ];
    maintainers = with maintainers; [ yrashk ];
  };
}
