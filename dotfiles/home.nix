{ config, pkgs,  ... }:
let 
	dotfiles = "${config.home.homeDirectory}/myfiles/dotfiles/manager";
	create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
	snr = "sudo nixos-rebuild ";
	etc-flag = " -I nixos-config=/etc/nixos/configuration.nix";
	flake-flag = " --flake ~/myfiles/dotfiles#NixPad";
	configs = {
		alacritty = "alacritty";
		fastfetch = "fastfetch";
		rofi = "rofi";
	};
in
{
	home = {
		username = "nixuser";
		homeDirectory = "/home/nixuser";
		stateVersion = "25.11";
	};

	xdg.configFile =
		builtins.mapAttrs (name: subpath: {
				source = create_symlink "${dotfiles}/${subpath}";
				recursive = true;
		}) configs;

	programs = {
		bash = {
			enable = true;
			shellAliases = {
				cde = "cd /etc/nixos && su";
				rebuild = snr + "switch" + etc-flag;
				redo = snr + "boot" + etc-flag + " && reboot";
				test = snr + "test" + etc-flag;

				cdf = "cd ~/myfiles/dotfiles";
				rebuildf = snr + "switch" + flake-flag;
				redof = snr + "boot" + flake-flag + " && reboot";
				testf = snr + "test" + flake-flag;

				ff = "clear && fastfetch";
				btw = "echo I use NixOS, btw";

				giveEthernet = "nmcli connection show && nmcli connection modify \"Wired connection 1\" ipv4.method shared && nmcli connection modify \"Wired connection 1\" ipv6.method ignore && nmcli connection down \"Wired connection 1\" && nmcli connection up \"Wired connection 1\"";
			};
		};
	};
}
