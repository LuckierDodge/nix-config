# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      #outputs.overlays.additions
      #outputs.overlays.modifications
      #outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # Set your username
  home = {
    username = "luckierdodge";
    homeDirectory = "/home/luckierdodge";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    htop
    gh
    duf
    tmux
    fzf
    starship
    redis
    tree
    du-dust
    pre-commit
    act
    lazydocker
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";

  # Dotfiles
  home.file = {
    ".aliases".source = ./dotfiles/.aliases;
    ".bashrc".source = ./dotfiles/.bashrc;
    ".dircolors".source = ./dotfiles/.dircolors;
    ".gitconfig".source = ./dotfiles/.gitconfig;
    ".gitmessage".source = ./dotfiles/.gitmessage;
    ".profile".source = ./dotfiles/.profile;
    ".tmux".source = ./dotfiles/.tmux;
    #".tmux.conf".source = ./dotfiles/.tmux.conf;
    ".config/alacritty/alacritty.toml".source = ./dotfiles/alacritty.toml;
    ".config/starship/starship.toml".source = ./dotfiles/starship.toml;
    ".sops.yaml".source = ./dotfiles/.sops.yaml;
    ".ssh/.keep".source = builtins.toFile "keep" "";
  };

  # Starship
  programs.starship.enable = true;

  # ZSH
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    autocd = true;
    history = {
      extended = true;
      ignoreDups = true;
      ignorePatterns = [ "exit" "ls" "ll" "la" "c" "clear" "cd" ];
      share = true;
      save = 20000;
      size = 20000;
    };
    initExtra = (builtins.readFile ./dotfiles/.zshrc);
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussel";
      plugins = [
        "git"
        "python"
        "vscode"
        "colored-man-pages"
        "command-not-found"
        "docker-compose"
        "docker"
        "pip"
        "ssh-agent"
        "sudo"
        "tmux"
        "starship"
        "fzf"
      ];
    };
    zplug = {
      enable = true;
      plugins = [
        { name = "lukechilds/zsh-nvm"; }
      ];
    };
  };

  # VIM
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      lightline-vim
    #  vim-surround
      vim-gitgutter
    #  ctrlp-vim
    #  supertab
    #  vim-fugitive
    #  vim-visual-multi
    #  vim-easymotion
    #  vim_current_word
      nord-vim
      nerdtree
      undotree
      vim-tmux-navigator
    ];
    extraConfig = (builtins.readFile ./dotfiles/.vimrc);
  };

  # TMUX
  programs.tmux = {
    enable = true;
    #shell = "\${pkgs.zsh}/bin/zsh";
    shortcut = "a";
    newSession = true;
    mouse = true;
    keyMode = "vi";
    historyLimit = 20000;
    escapeTime = 50;
    clock24 = true;
    aggressiveResize = true;
    plugins = with pkgs.tmuxPlugins; [
      battery
      prefix-highlight
      online-status
      sidebar
      copycat
      open
      sysstat
      vim-tmux-navigator
    ];
    extraConfig = (builtins.readFile ./dotfiles/.tmux.conf);
  };
}
