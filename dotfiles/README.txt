Flakes:

After running "sudo nixos-rebuild switch --flake ~/dotfiles#NixPad", you will get the following error message - 
"error: file 'nixos-config' was not found in the Nix search path (add it using $NIX_PATH or -I)
Command 'nix-build '<nixpkgs/nixos>' --attr config.system.build.nixos-rebuild --no-out-link' returned non-zero exit status 1.". 

This just means that because you specified a path to a flake before, it's expecting a path to be proclaimed at all times. 
To fix this and go back to using your /etc/nixos directory, run the following - 
"sudo nixos-rebuild switch -I nixos-config=/etc/nixos/configuration.nix". 

After that your usual commands should work.

-------------------------------------------------------------------------------------

Bootloader:

These two lines definetly work, so if grub does not work, then this does - "
boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;"

Otherwise this grub set should work too - "
boot.loader = {
	systemd-boot.enable = false;
	grub = {
		enable = true;
		device = "nodev";
		useOSProber = true;
		efiSupport = true;
	};
	efi = {
		canTouchEfiVariables = true;
		efiSysMountPoint = "/boot";
	};
};"

HOWEVER! ~ I don't know why but grub seems to make a new boot directory called "NixOS-bootloader" which takes priority. Undoing grub from your system seems tedious and I am not sure how to do it yet. Unless you have a reason to even use grub, I wouldn't. I accidently broke my system trying to remove it - note that you should definetly read how to back it up and use the grub recovery mode!
