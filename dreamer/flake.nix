{
  inputs =  {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pyvista = {
      type = "github";
      owner = "GlennWSo";
      repo = "pyvista";
      rev = "c871273f8c75cc78b187601048aca46554fd4336";
    };
  };

  outputs = { self, nixpkgs, flake-utils,  pyvista}:

    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit  system;
        };
        py = pkgs.python310Packages;

        pyLibPath = pkgs.lib.makeLibraryPath [
          # pyvista
        ];
        
        # libPath = with pkgs; pkgs.lib.makeLibraryPath [
        #       stdenv.cc.cc.lib
        #       libglvnd
        #       libGLU
        #       fontconfig
        #       xorg.libX11
        #       xorg.libXrender
        #       xorg.libXcursor
        #       xorg.libXfixes
        #       xorg.libXft
        #       xorg.libXinerama
        #       xorg.libXmu
        #       zlib
        #     ];

      in
        rec {

          defaultPackage = pyvista.packages.${system}.default;
          devShell = pkgs.mkShell rec {
            name = "flake pyrust";
            venvDir = ".venv";

            buildInputs = [
              pkgs.nil
              defaultPackage
            ];

            # shellHook = ''
            #   SOURCE_DATE_EPOCH=$(date +%s)

            #   if [ -d "${venvDir}" ]; then
            #     echo "Skipping venv creation, '${venvDir}' already exists"
            #     source "${venvDir}/bin/activate"
            #   else
            #     echo "Creating new venv environment in path: '${venvDir}'"
            #     # Note that the module venv was only introduced in python 3, so for 2.7
            #     # this needs to be replaced with a call to virtualenv
            #     ${py.python.interpreter} -m venv "${venvDir}"
            #     source "${venvDir}/bin/activate"
            #     # pip install  .               
            #     # pip install -e .    
            #   fi

            #   # PYTHONPATH=$PWD/${venvDir}/${pyEnv.python.sitePackages}/:$PYTHONPATH
            #   export PYTHONPATH=${pyLibPath}/python3.9/site-packages/:$PYTHONPATH
            #   # export LD_LIBRARY_PATH=${libPath}:$LD_LIBRARY_PATH
            #   # pip install -r requirements.txt

            # '';
          };
        }
    );
}

