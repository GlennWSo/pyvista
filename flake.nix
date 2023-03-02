{
  inputs.dream2nix.url = "github:nix-community/dream2nix";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = inp:
    inp.dream2nix.lib.makeFlakeOutputs {
      systems = inp.flake-utils.lib.defaultSystems;
      config.projectRoot = ./.;
      source = ./.;
      projects = ./projects.toml;
    };
}
