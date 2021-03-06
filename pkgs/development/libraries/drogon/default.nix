{ stdenv, fetchFromGitHub, cmake, jsoncpp, libossp_uuid, zlib, openssl, lib }:

stdenv.mkDerivation rec {
  pname = "drogon";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "an-tao";
    repo = "drogon";
    rev = "v${version}";
    sha256 = "18wn9ashv3h3pal6x5za6y7byfcrd49zy3wfx4hx0ygxzplmss0r";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_TESTING=${if doInstallCheck then "ON" else "OFF"}"
    "-DBUILD_EXAMPLES=OFF"
  ];

  propagatedBuildInputs = [
    jsoncpp
    libossp_uuid
    zlib
    openssl
  ];

  patches = [
    # this part of the test would normally fail because it attempts to configure a CMake project that uses find_package on itself
    # this patch makes drogon and trantor visible to the test
    ./fix_find_package.patch
  ];

  # modifying PATH here makes drogon_ctl visible to the test
  installCheckPhase = ''
    cd ..
    patchShebangs test.sh
    PATH=$PATH:$out/bin ./test.sh
  '';

  doInstallCheck = true;

  meta = with lib; {
    homepage = "https://github.com/an-tao/drogon";
    description = "C++14/17 based HTTP web application framework";
    license = licenses.mit;
    maintainers = [ maintainers.urlordjames ];
    platforms = platforms.all;
  };
}
