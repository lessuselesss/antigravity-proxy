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
      packages.${system}.default = pkgs.writeScriptBin "antigravity-proxy" ''
        #!${pkgs.bash}/bin/bash
        ${pkgs.python3Packages.mitmproxy}/bin/mitmproxy -s ${./mitmproxy-addon.py} --set block_global=false
      '';

      apps.${system}.default = {
        type = "app";
        program = "${self.packages.${system}.default}/bin/antigravity-proxy";
      };

    };
}
