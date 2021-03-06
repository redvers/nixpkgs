{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "gdu";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "dundee";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-OellGxW/2I/dKBxWgEv1Ta9OJ/2HUfDIzICQwvmjTCM=";
  };

  vendorSha256 = "sha256-9W1K01PJ+tRLSJ0L7NGHXT5w5oHmlBkT8kwnOLOzSCc=";

  nativeBuildInputs = [ installShellFiles ];

  buildFlagsArray = [
    "-ldflags="
    "-s"
    "-w"
    "-X github.com/dundee/gdu/v${lib.versions.major version}/build.Version=${version}"
  ];

  postPatch = ''
    substituteInPlace cmd/gdu/app/app_test.go --replace "development" "${version}"
  '';

  postInstall = ''
    installManPage gdu.1
  '';

  # doCheck = !(stdenv.isAarch64 || stdenv.isDarwin);
  # also fails x86_64-linux on hydra with:
  # dir_test.go:82:
  #             Error Trace:    dir_test.go:82
  #             Error:          Not equal:
  #                             expected: 0
  #                             actual  : 512
  #             Test:           TestFlags
  doCheck = false;

  meta = with lib; {
    description = "Disk usage analyzer with console interface";
    longDescription = ''
      Gdu is intended primarily for SSD disks where it can fully
      utilize parallel processing. However HDDs work as well, but
      the performance gain is not so huge.
    '';
    homepage = "https://github.com/dundee/gdu";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.fab ];
    platforms = platforms.unix;
  };
}
