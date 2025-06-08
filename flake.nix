{
  description = "Home Manager configuration of mkr";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      homeManagerCfgs = [
        ./home.nix
        ./hyprland.nix
        ./packages.nix
      ];
    in
    {
      homeConfigurations."mkr@elektra" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = homeManagerCfgs ++ [
          ./elektra/nvim.nix
          ./elektra/hyprland.nix
          ./elektra/waybar.nix
          ./elektra/zsh.nix
          ./elektra/gtk.nix
          ./elektra/kitty.nix
          ./elektra/digital-audio-workstation.nix
          ./elektra/eww.nix
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
      homeConfigurations."mkr@erika" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = homeManagerCfgs ++ [
          ./erika/nvim.nix
          ./erika/hyprland.nix
          ./erika/waybar.nix
          ./erika/zsh.nix
          ./erika/gtk.nix
          ./erika/kitty.nix
          ./erika/digital-audio-workstation.nix
          ./erika/eww.nix
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
