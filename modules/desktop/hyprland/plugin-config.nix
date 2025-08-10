{ ... }: {
  wayland.windowManager.hyprland.settings = {
    # Plugin configurations converted from plugins.conf
    debug = {
      disable_logs = false;
    };
    
    plugin = {
      # Hyprexpo plugin configuration (workspace overview)
      hyprexpo = {
        columns = 3;
        gap_size = 5;
        workspace_method = "center current";
        
        enable_gesture = true;
        gesture_fingers = 4;
        gesture_distance = 150;
        gesture_positive = true;
      };
      
      # Overview plugin configuration (alternative workspace overview)
      overview = {
        onBottom = true;
        centerAligned = true;
        hideBackgroundLayers = true;
        drawActiveWorkspace = true;
        affectStrut = true;
        gestures = {
          workspace_swipe_fingers = 3;
        };
      };
      
      # Hyprsplit plugin configuration (i3/dwm-like workspaces)
      hyprsplit = {
        num_workspaces = 5;
        persistent_workspaces = true;
      };
    };
  };
}