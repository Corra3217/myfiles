{ config, lib, pkgs, inputs, ... }:
let 
testpkgs = inputs.unstable.legacyPackages.x86_64-linux;
in
{
	imports = [ 
		./hardware-configuration.nix 
	];

	system.stateVersion = "25.11";

	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	boot = {
		kernelModules = [ "rtw89pci" "rtw89usb" ];
		kernelPackages = pkgs.linuxPackages_latest;
		loader = {
			systemd-boot.enable = true;
			efi.canTouchEfiVariables = true;
		};
	};

	hardware.enableRedistributableFirmware = true;
	hardware.bluetooth.enable = true;

	networking.hostName = "NixPad";
	networking.networkmanager.enable = true;

	time.timeZone = "Australia/Sydney";

	powerManagement.enable = true;

	nixpkgs.config.allowUnfree = true;
	nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
		"steam"
		"steam-original"
		"steam-unwrapped"
		"steam-run"
	];

	services = {
		blueman.enable = true;

		pipewire = {
			enable = true;
			pulse.enable = true;
		};

		displayManager.sddm = {
			enable = true;
			wayland.enable = true;
		};

		desktopManager.plasma6.enable = true;
	};

	users = {
		extraGroups.vboxusers.members = [ "nixuser" ];
		users.nixuser = {
			isNormalUser = true;
			extraGroups = [ "wheel" "networkmanager" ];
			packages = with pkgs; [ 
				testpkgs.tor-browser
				testpkgs.tigervnc
				testpkgs.fastfetch
				testpkgs.vlc
				discord
			];
		};
	};

	virtualisation.virtualbox = {
		host = {
			enable = true;
			enableExtensionPack = true;
			enableKvm = true;
			addNetworkInterface = false;
		};
	};

	programs.steam.enable = true; 

	environment.systemPackages = with pkgs; [
		testpkgs.man-db
		testpkgs.git
		testpkgs.firefox
		testpkgs.pcmanfm

		wget
		htop
		iwd
		tealdeer

		sddm-astronaut
		rofi
		pamixer
		pavucontrol
		brightnessctl	

		alacritty 
		nano
		vim
		unzip

		tree
		gedit
		nil # learn now this works
		gimp
		usbutils

		kdePackages.discover # Optional: Install if you use Flatpak or fwupd firmware update sevice
		kdePackages.kcalc # Calculator
		kdePackages.kcharselect # Tool to select and copy special characters from all installed fonts
		kdePackages.kclock # Clock app
		kdePackages.kcolorchooser # A small utility to select a color
		kdePackages.kolourpaint # Easy-to-use paint program
		kdePackages.ksystemlog # KDE SystemLog Application
		kdePackages.sddm-kcm # Configuration module for SDDM
		kdiff3 # Compares and merges 2 or 3 files or directories
		kdePackages.isoimagewriter # Optional: Program to write hybrid ISO files onto USB disks
		kdePackages.partitionmanager # Optional: Manage the disk devices, partitions and file systems on your computer
		hardinfo2 # System information and benchmarks for Linux systems
		vlc # Cross-platform media player and streaming server
		wayland-utils # Wayland utilities
		wl-clipboard # Command-line copy/paste utilities for Wayland
	];
}
