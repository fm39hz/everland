{ ... }: {
  wayland.windowManager.hyprland.settings = {
    # Window rules converted from external config files
    windowrulev2 = [
      # Firefox/Browser rules
      "float,class:(floorp),title:(Library)"
      "float,class:(floorp),title:^(Đăng nhập - Tài khoản Google)^$"
      "float,intialClass:(zen),title:(Extension:.*)"
      
      # Steam gaming rules
      "workspace special:trash,initialClass:( ),initialTitle:(Steam)"
      "workspace 1,initialClass:(steam),initialTitle:(Steam Big Picture Mode)"
      "workspace 1,initialClass:(eastward.exe),initialTitle:(Eastward)"
      "stayfocused,title:^()$,class:^(steam)$"
      "minsize 1 1,title:^()$,class:^(steam)$"
      "workspace special:debug,initialClass:(XTerm),initialTitle:(env)"
      
      # Electron app rules
      "opacity 1.0 override,class:^()$,title:^()$"
      "noblur,class:^()$,title:^()$"
      "float,initialClass:(brave-.*-Default)"
      "float,initialTitle:(Untitled - Brave)"
      "workspace special:chat,initialClass:(Thorium-browser),initialTitle:(Facebook)"
      "tile,initialClass:(Thorium-browser),initialTitle:(Facebook)"
      "float,initialClass:(xdg-desktop-portal-gtk)"
      
      # JetBrains IDE rules (commented out in original)
      # "tag +jb,class:^jetbrains-.+$,floating:1"
      # "stayfocused,tag:jb"
      # "noinitialfocus,tag:jb"
      # "move 30% 30%,class:^jetbrains-(!toolbox),title:^(!win.*),floating:1"
      # "size 40% 40%,class:^jetbrains-(!toolbox),title:^(!win.*),floating:1"
      # "dimaround,class:^(jetbrains-*)$,title:^((Select)|(Choose) )"
      
      # GTK app rules
      "float,initialClass:(org.gnome.Calculator),initialTitle:(Calculator)"
      "size 360 616,initialClass:(org.gnome.Calculator),initialTitle:(Calculator)"
      "center true,initialClass:(org.gnome.Calculator),initialTitle:(Calculator)"
      "nofocus,title:^(Ibus-ui-gtk3)$"
      
      # Godot engine rules
      "workspace special:debug,initialClass:(Game.*),initialTitle:(Godot)"
      "workspace special:debug,initialClass:(Project)(.*),initialTitle:(Godot)"
      "workspace special:debug,initialTitle:(.*)(DEBUG)(.*),initialClass:(Godot)"
      "tile,initialClass:(Godot),initialTitle:(Godot)"
      
      # Laigter (texture tool) rules
      "float,class:(laigter),title:(Export)"
      "float,class:(laigter),title:(Form)"
    ];
  };
}