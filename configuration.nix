# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, callPackage, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "bb8"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "America/Miami";

  # links libexec to /run/current-system/sw
  environment.pathsToLink = [ "/libexec" ];

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp7s0.useDHCP = true;
  networking.interfaces.wlp6s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
   console = {
     font = "Lat2-Terminus16";
     keyMap = "dvorak";
   };

  # Enable the X11 + i3 + xfkce windowing & desktop system.
  services.xserver = {
	enable = true;
	layout = "us";
	xkbVariant = "dvorak";
	displayManager.defaultSession = "none+i3";
	windowManager.i3 = {
		enable = true;
		extraPackages = with pkgs; [
			dmenu
			i3status
			i3lock
			i3blocks
		];
	};
  };
	
  
  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable TLP to preserve battery life
  services.tlp.enable = true;

  # Enable sound.
   sound.enable = true;
   hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

 # virtualisation.docker.enable=true;
  virtualisation.virtualbox.host.enable = true;
   users.extraGroups.vboxusers.members = [ "sean" ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.sean = {
     isNormalUser = true;
     extraGroups = [
       "wheel"
       "docker"
       "sudo"
     ]; # Enable ‘sudo’ for the user.
   };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.variables = {EDITOR = "vim_configurable"; };

  environment.systemPackages = with pkgs; 
   [
     (let
      my-python-packages = python-packages: with python-packages; [
	setuptools
	pydantic
	motor	
	pytest
        pandas
        requests
        sqlalchemy
        psycopg2
        numpy
	    fastapi
        pytest
        apache-airflow
	    virtualenv
      ];
      python-with-pkgs = python3.withPackages my-python-packages;
     in
     python-with-pkgs)
     vim_configurable # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     git
     fish
     git-doc
     wget
     firefox
     docker
     vagrant
     packer
     terraform
     aws
     gh	    
     zenith
     neofetch
     ((vim_configurable.override { python = python3; }).customize{
         name = "vim";
         vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
            start = [ vim-nix vim-lastplace ];
            opt = [];
         };
    }
  ) 
   ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  environment.binsh = "${pkgs.dash}/bin/dash";

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 96 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}
