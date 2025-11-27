{
  description = "A Nix flake for the Antigravity Proxy";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system}.default = let
        pythonEnv = pkgs.python3.withPackages (ps: [
          ps.mitmproxy
          ps.python-dotenv
        ]);
      in
      pkgs.writeScriptBin "antigravity-proxy" ''
        #!${pkgs.bash}/bin/bash
        ${pythonEnv}/bin/mitmproxy -s ${./mitmproxy-addon.py} --set block_global=false
      '';

      apps.${system}.default = {
        type = "app";
        program = "${self.packages.${system}.default}/bin/antigravity-proxy";
      };

    };
}
