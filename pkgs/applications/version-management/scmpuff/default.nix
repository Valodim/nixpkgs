{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "scmpuff";
  version = "0.3.0";

  goPackagePath = "github.com/mroth/scmpuff";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "mroth";
    repo = "scmpuff";
    rev = "v${version}";
    sha256 = "0zrzzcs0i13pfwcqh8qb0sji54vh37rdr7qasg57y56cqpx16vl3";
  };

  meta = with stdenv.lib; {
    description = "add numbered shortcuts to common git commands";
    homepage = "https://github.com/mroth/scmpuff";
    license = licenses.mit;
    maintainers = with maintainers; [ valodim ];
  };
}
