{ ... }: {
  wayland.windowManager.hyprland.settings = {
    # Environment variables from environment.conf
    env = [
      "XCURSOR_SIZE,24"
      "XMODIFIERS,@im=fcitx"
      "_JAVA_AWT_WM_NONREPARENTING,1"
      "GTK_IM_MODULE,fcitx"
      "QT_IM_MODULE,fcitx"
      "XDG_SESSION_TYPE,wayland"
      "XDG_SESSION_DESKTOP,hyprland"
      "GDK_BACKEND,wayland,x11"
      "QT_QPA_PLATFORM,wayland"
      "MOZ_ENABLE_WAYLAND,1"
      "HYPRCURSOR_THEME,everforest-cursors"
      "HYPRCURSOR_SIZE,32"
      "AQ_DRM_DEVICES,/dev/dri/card1"
      "WLR_DRM_DEVICES,/dev/dri/card1"
      "AQ_DRM_DEVICES,/dev/dri/card1"
      "AQ_WLR_DEVICES,/dev/dri/card1"
    ];
  };
}
