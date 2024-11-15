{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "desk-exec";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "AxerTheAxe";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-bJLdd07IAf+ba++vtS0iSmeQSGygwSVNry2bHTDAgjE=";
  };

  cargoHash = "sha256-pK1WDtGkpPZgFwEm59TqoH7EkKPQivNuvsiOG0dbum4=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion target/${stdenv.targetPlatform.config}/release/dist/desk-exec.{bash,fish}
    installManPage target/${stdenv.targetPlatform.config}/release/dist/desk-exec.1
  '';

  meta = with lib; {
    description = "Execute programs defined in XDG desktop entries directly from the command line";
    homepage = "https://github.com/AxerTheAxe/desk-exec";
    license = licenses.unlicense;
    maintainers = [ maintainers.axertheaxe ];
    platforms = platforms.linux;
  };
}
