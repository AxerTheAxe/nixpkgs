{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libsForQt5,
  libpng,
  giflib,
  libjpeg,
  impy,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "evilpixie";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "bcampbell";
    repo = "evilpixie";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-+DdAN+xDOYxLgLHUlr75piTEPrWpuOyXvxckhBEl7yU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtbase
    libpng
    giflib
    libjpeg
    impy
  ];

  meta = with lib; {
    description = "Pixel-oriented paint program, modelled on Deluxe Paint";
    mainProgram = "evilpixie";
    homepage = "https://github.com/bcampbell/evilpixie"; # http://evilpixie.scumways.com/ is gone
    downloadPage = "https://github.com/bcampbell/evilpixie/releases";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
    # Undefined symbols for architecture x86_64:
    # "_bundle_path", referenced from: App::SetupPaths() in src_app.cpp.o
    broken =
      stdenv.hostPlatform.isDarwin
      ||
        # https://github.com/bcampbell/evilpixie/issues/28
        stdenv.hostPlatform.isAarch64;
  };
})
