{
  # If you want to use the in-tree version of nixpkgs:
  pkgs ? import ../../../../.. {
    config.allowUnfree = true;
  },

  licenseAccepted ? pkgs.callPackage ../license.nix { },
}:

# Tests IFD with androidenv. Needs a folder of `../xml` in your local tree;
# use ../fetchrepo.sh to produce it.
let
  androidEnv = pkgs.callPackage ./.. {
    inherit pkgs licenseAccepted;
  };

  sdkArgs = {
    repoXmls = {
      packages = [ ../xml/repository2-3.xml ];
      images = [
        ../xml/android-sys-img2-3.xml
        ../xml/android-tv-sys-img2-3.xml
        ../xml/google_apis-sys-img2-3.xml
        ../xml/google_apis_playstore-sys-img2-3.xml
        ../xml/android-wear-sys-img2-3.xml
        ../xml/android-wear-cn-sys-img2-3.xml
        ../xml/android-automotive-sys-img2-3.xml
      ];
      addons = [ ../xml/addon2-3.xml ];
    };
  };

  androidComposition = androidEnv.composeAndroidPackages sdkArgs;
  androidSdk = androidComposition.androidsdk;
  platformTools = androidComposition.platform-tools;
  jdk = pkgs.jdk;
in
pkgs.mkShell {
  name = "androidenv-example-ifd-demo";
  packages = [
    androidSdk
    platformTools
    jdk
  ];

  LANG = "C.UTF-8";
  LC_ALL = "C.UTF-8";
  JAVA_HOME = jdk.home;

  # Note: ANDROID_HOME is deprecated. Use ANDROID_SDK_ROOT.
  ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";

  shellHook = ''
    # Write out local.properties for Android Studio.
    cat <<EOF > local.properties
    # This file was automatically generated by nix-shell.
    sdk.dir=$ANDROID_SDK_ROOT
    EOF
  '';
}
