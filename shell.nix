{ nixpkgs ? import <nixpkgs> {}, compiler ? "default" }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, aeson, base, optparse-applicative, pandoc
      , stdenv, text
      }:
      mkDerivation {
        pname = "tyme2invoice";
        version = "0.0.0.1";
        src = ./.;
        isLibrary = true;
        isExecutable = true;
        libraryHaskellDepends = [
          aeson base optparse-applicative pandoc text
        ];
        executableHaskellDepends = [ base ];
        homepage = "https://github.com/yurrriq/tyme2invoice";
        description = "Generate pretty invoices from Tyme 2 logs";
        license = stdenv.lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  drv = haskellPackages.callPackage f {};

in

  if pkgs.lib.inNixShell then drv.env else drv
