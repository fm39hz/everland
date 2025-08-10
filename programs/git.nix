{ pkgs, personal, ... }:

{
  # Git configuration
  programs.git = {
    enable = true;
    lfs.enable = true;
    extraConfig = {
      init.defaultBranch = "master";
      pull.rebase = true;
      core.editor = "nvim";
      user.name = personal.name;
      user.email = personal.email;
    };
  };

  programs.lazygit.enable = true;
  
  # GitHub CLI configuration
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "https";
      editor = "nvim";
    };
  };

  # Git-related packages
  home.packages = with pkgs; [
    diff-so-fancy
    git-lfs
  ];
}
