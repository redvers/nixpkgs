{ stdenv, fetchFromGitHub, libbsd }: 

stdenv.mkDerivation rec {
  pname = "brightlight";
  version = "v8";

  src = fetchFromGitHub {
    owner = "multiplexd";
    repo = pname;
    rev = version;
    sha256 = "1sfvs4j0mfcmr2v2gybyi0b62pkp04yxkh7dq7lhjjcyrm24c74r";
  };

  buildInputs = [ libbsd ];

  ## Package Makefile has no install target
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin ## $out is a special variable that expands to /nix/store/klqwjehdlkjwqhdlkjhqwlekhlqw-package-ver/
    cp brightlight $out/bin

    runHook postInstall
  '';

  meta = {
    description = "Get and set backlight brightness usings sysfs";
    longDescription = ''
      This is backlight which uses the sysfs interface instead of acpi.
      There may be compatibility reasons for doing this.
    '';
    homepage = https://github.com/multiplexd/brighlight;
    license = stdenv.lib.licenses.isc;
    maintainers = [ stdenv.lib.maintainers.redvers ];
    platforms = stdenv.lib.platforms.linux;
  };
}
