-- ################
-- ### MONITORS ###
-- ################

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
hl.monitor({ output = "eDP-1", mode = "1920x1080@60", position = "auto", scale = 1.2 })
hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})


-- ###################
-- ### MY PROGRAMS ###
-- ###################

-- See https://wiki.hypr.land/Configuring/Basics/Binds/

-- Set programs that you use
local terminal    = "kitty"
local fileManager = "nemo"
local browser     = "firefox"
local code        = "code"
local notes       = "kwrite"
-- execute wofi only if there is no other instance running
local menu = "pidof wofi && killall wofi || wofi --show drun --insensitive"


-- #################
-- ### AUTOSTART ###
-- #################

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:

-- hl.on("hyprland.start", function()
--   hl.exec_cmd(terminal)
--   hl.exec_cmd("nm-applet")
--   hl.exec_cmd("waybar & hyprpaper & firefox")
-- end)

-- execution of utilities
hl.on("hyprland.start", function()
    hl.exec_cmd([[(hyprlock && sleep 0.2 && hyprctl reload) & hyprpaper & pulseaudio & swaync & waybar & wl-paste --watch cliphist store & udiskie --no-notify & /usr/lib/hyprpolkitagent/hyprpolkitagent]])
    hl.exec_cmd([[sh -c "sleep 2 && hyprctl hyprpaper wallpaper ', /home/ilwan/.config/wallpapers/wallpaper.jpg, cover'"]])
    -- execution of config commands
    hl.exec_cmd("xrdb ~/.Xresources")
end)

-- set themes
hl.exec_cmd('gsettings set org.gnome.desktop.interface gtk-theme "Fluent-Dark"')
hl.exec_cmd('gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"')
hl.exec_cmd('gsettings set org.gnome.desktop.interface cursor-theme "Oxygen_White"')


-- #############################
-- ### ENVIRONMENT VARIABLES ###
-- #############################

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_THEME", "Oxygen_White")
hl.env("XCURSOR_SIZE",  "24")

hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_QPA_PLATFORM",      "wayland")
hl.env("HYPRSHOT_DIR",         "Pictures/Screenshots")

-- auto-update ohmyzsh without prompting
hl.env("DISABLE_UPDATE_PROMPT", "true")


-- #####################
-- ### LOOK AND FEEL ###
-- #####################

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/

-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
hl.config({
    general = {
        gaps_in  = 3,
        gaps_out = 4,

        border_size = 2,

        -- https://wiki.hypr.land/Configuring/Basics/Variables/#variable-types for info about colors
        col = {
            active_border   = { colors = { "rgba(33ccffbb)", "rgba(00ff99bb)" }, angle = 45 },
            inactive_border = "rgba(00ced155)",
        },

        -- Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "dwindle",
    },

    -- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
    decoration = {
        rounding       = 8,
        rounding_power = 8,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 0.97,
        inactive_opacity = 0.95,
        dim_inactive     = true,
        dim_strength     = 0.1,

        shadow = {
            enabled      = true,
            range        = 5,
            render_power = 3,
            color        = "rgba(00a0aaee)",
        },

        -- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/#blur
        blur = {
            enabled   = true,
            size      = 4,
            passes    = 1,
            vibrancy  = 0.1696,
        },
    },

    -- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
    animations = {
        enabled = true,
    },
})

-- Default animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/ for more

hl.curve("easeOutQuint",   { type = "bezier", points = { { 0.23, 1    }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear",         { type = "bezier", points = { { 0,    0    }, { 1,    1 } } })
hl.curve("almostLinear",   { type = "bezier", points = { { 0.5,  0.5  }, { 0.75, 1 } } })
hl.curve("quick",          { type = "bezier", points = { { 0.15, 0    }, { 0.1,  1 } } })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default"       })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint"  })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint"  })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick"        })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, border_size = 0 })
-- hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, rounding = 0 })
-- hl.window_rule({ match = { float = false, workspace = "f[1]"   }, border_size = 0 })
-- hl.window_rule({ match = { float = false, workspace = "f[1]"   }, rounding = 0 })

-- See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
    },
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#misc
hl.config({
    misc = {
        force_default_wallpaper  = 0,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_splash_rendering = true, -- Disable splash text when hyprpaper is not running
        disable_hyprland_logo    = true, -- If true disables the random hyprland logo / anime girl background
    },
})


-- #############
-- ### INPUT ###
-- #############

-- https://wiki.hypr.land/Configuring/Basics/Variables/#input
hl.config({
    input = {
        kb_layout  = "fr",
        kb_variant = "oss_latin9",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",
        numlock_by_default = true,

        follow_mouse = 1,

        sensitivity  = 0.4, -- -1.0 - 1.0, 0 means no modification.
        accel_profile = "flat",

        touchpad = {
            natural_scroll       = true,
            scroll_factor        = 0.5,
            disable_while_typing = true,
        },
    },

    cursor = {
        inactive_timeout = 10,
    },
})

-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/
hl.config({
    gestures = {
        workspace_swipe_forever = true,
    },
})
hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


-- ###################
-- ### KEYBINDINGS ###
-- ###################

-- See https://wiki.hypr.land/Configuring/Basics/Binds/
local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Move a window to the specified workspace, and also do some other stuff (makes cava visualizer follow g4music)
local function move_cmd(ws)
    local w = hl.get_active_window()
    if w ~= nil and w.class == "com.github.neithern.g4music" then
        hl.dispatch(hl.dsp.window.move({ workspace = ws, window = "class:cava-g4music", silent = true }))
    end
    hl.dispatch(hl.dsp.window.move({ workspace = ws }))
end

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + return",    hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + less",      hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C",         hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.window.kill())
hl.bind(mainMod .. " + L",         hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + escape",    hl.dsp.exec_cmd("pidof wofi && killall wofi || ~/.config/hypr/scripts/power-menu.sh"))
hl.bind(mainMod .. " + U",         hl.dsp.exec_cmd("hyprctl eval 'hl.config({input={touchpad={disable_while_typing=false}}})'"))
hl.bind(mainMod .. " + SHIFT + U", hl.dsp.exec_cmd("hyprctl eval 'hl.config({input={touchpad={disable_while_typing=true}}})'"))
hl.bind(mainMod .. " + E",         hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + semicolon", hl.dsp.exec_cmd("smile"))
hl.bind(mainMod .. " + CTRL + M",  hl.dsp.exec_cmd("killall -q setwallpaper.sh; (pidof hyprpaper || hyprpaper & sleep 0.2); ~/.stuff/setwallpaper.sh"))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd('killall -q setwallpaper.sh; killall hyprpaper; hyprpaper & sleep 0.2 && hyprctl hyprpaper wallpaper ", ~/.config/wallpapers/hyprpaper.png"'))
hl.bind(mainMod .. " + ALT + M",   hl.dsp.exec_cmd('killall -q setwallpaper.sh; killall hyprpaper; hyprpaper & sleep 0.2 && hyprctl hyprpaper wallpaper ", ~/.config/wallpapers/wallpaper.jpg"'))
hl.bind(mainMod .. " + M",         hl.dsp.exec_cmd("python ~/.config/hypr/scripts/choose-wallpaper.py -m cover"))
hl.bind(mainMod .. " + SHIFT + CTRL + M", hl.dsp.exec_cmd("python ~/.config/hypr/scripts/choose-wallpaper.py"))
hl.bind(mainMod .. " + J",         hl.dsp.exec_cmd([[hyprctl eval 'hl.config({input={kb_variant="",kb_layout="us"}})']]))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.exec_cmd([[hyprctl eval 'hl.config({input={kb_layout="fr",kb_variant="oss_latin9"}})']]))
hl.bind(mainMod .. " + W",         hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + space",     hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + F",         hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.exec_cmd(browser .. " -private-window"))
hl.bind(mainMod .. " + O",         hl.dsp.exec_cmd(code))
hl.bind(mainMod .. " + K",         hl.dsp.exec_cmd(notes))
hl.bind(mainMod .. " + G",         hl.dsp.exec_cmd([[hyprctl clients | grep "class: cava-g4music" || kitty --class "cava-g4music" -o confirm_os_window_close=0 -o background_opacity=0 -e "cava" & g4music; hyprctl dispatch "hl.dsp.window.kill({window='class:cava-g4music'})"]]))
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.exec_cmd([[hyprctl clients | grep "class: cava-free" && hyprctl dispatch "hl.dsp.window.kill({window='class:cava-free'})" || kitty --class "cava-free" -o confirm_os_window_close=0 -o background_opacity=0 -e "cava"]]))
hl.bind(mainMod .. " + Y",         hl.dsp.exec_cmd("sudo ~/.config/hypr/scripts/homevpn-up.sh && notify-send 'Home VPN Up' || notify-send 'Error: Failed to get Home VPN Up'"))
hl.bind(mainMod .. " + SHIFT + Y", hl.dsp.exec_cmd("sudo ~/.config/hypr/scripts/homevpn-down.sh && notify-send 'Home VPN Down' || notify-send 'Home VPN already Down'"))
hl.bind(mainMod .. " + SHIFT + CTRL + B", hl.dsp.exec_cmd("sudo ~/.config/hypr/scripts/restart-bluetooth.sh"))
hl.bind(mainMod .. " + SHIFT + CTRL + W", hl.dsp.exec_cmd("sudo ~/.config/hypr/scripts/restart-network.sh"))
hl.bind(mainMod .. " + P",         hl.dsp.window.pin())
hl.bind(mainMod .. " + T",         hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.layout("swapsplit"))
hl.bind(mainMod .. " + F11",       hl.dsp.window.fullscreen())

-- Utilities
hl.bind("PRINT",                   hl.dsp.exec_cmd("hyprshot -m output -m active"))
hl.bind(mainMod .. " + PRINT",     hl.dsp.exec_cmd("hyprshot -m window -m active"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind(mainMod .. " + V",         hl.dsp.exec_cmd([[pidof wofi && killall wofi || cliphist list | wofi -S dmenu | awk 'NF{print | "cliphist decode | wl-copy"; close("cliphist decode | wl-copy")}']]))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd('cliphist wipe && wl-copy ""'))
hl.bind(mainMod .. " + N",         hl.dsp.exec_cmd("swaync-client -t"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("swaync-client -C"))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "d" }))

-- Switch workspaces with mainMod + [0-9] (French AZERTY bindings)
hl.bind(mainMod .. " + ampersand",  hl.dsp.focus({ workspace = 1  }))
hl.bind(mainMod .. " + eacute",     hl.dsp.focus({ workspace = 2  }))
hl.bind(mainMod .. " + quotedbl",   hl.dsp.focus({ workspace = 3  }))
hl.bind(mainMod .. " + apostrophe", hl.dsp.focus({ workspace = 4  }))
hl.bind(mainMod .. " + parenleft",  hl.dsp.focus({ workspace = 5  }))
hl.bind(mainMod .. " + minus",      hl.dsp.focus({ workspace = 6  }))
hl.bind(mainMod .. " + egrave",     hl.dsp.focus({ workspace = 7  }))
hl.bind(mainMod .. " + underscore", hl.dsp.focus({ workspace = 8  }))
hl.bind(mainMod .. " + ccedilla",   hl.dsp.focus({ workspace = 9  }))
hl.bind(mainMod .. " + agrave",     hl.dsp.focus({ workspace = 10 }))

-- Move active window to a workspace with mainMod + SHIFT + [0-9] (French AZERTY bindings) + execute command on move
hl.bind(mainMod .. " + SHIFT + ampersand",  function() move_cmd(1)  end)
hl.bind(mainMod .. " + SHIFT + eacute",     function() move_cmd(2)  end)
hl.bind(mainMod .. " + SHIFT + quotedbl",   function() move_cmd(3)  end)
hl.bind(mainMod .. " + SHIFT + apostrophe", function() move_cmd(4)  end)
hl.bind(mainMod .. " + SHIFT + parenleft",  function() move_cmd(5)  end)
hl.bind(mainMod .. " + SHIFT + minus",      function() move_cmd(6)  end)
hl.bind(mainMod .. " + SHIFT + egrave",     function() move_cmd(7)  end)
hl.bind(mainMod .. " + SHIFT + underscore", function() move_cmd(8)  end)
hl.bind(mainMod .. " + SHIFT + ccedilla",   function() move_cmd(9)  end)
hl.bind(mainMod .. " + SHIFT + agrave",     function() move_cmd(10) end)

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + twosuperior", hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind(mainMod .. " + SHIFT + twosuperior", function() move_cmd("special:scratchpad") end)

-- Scroll through existing workspaces with mainMod + scroll/arrow/tab
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_down",   hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + left",   hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + tab", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + SHIFT + tab",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272",         hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + SHIFT + mouse:272", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5% && pactl set-sink-mute @DEFAULT_SINK@ false"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%"),                                             { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"),                                            { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),                                         { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl s 5%+ && hyprctl dismissnotify -1 && hyprctl notify 2 2000 0 \"brightness $(brightnessctl g | awk -v max=$(brightnessctl m) 'BEGIN{} {printf \"%.0f%%\", ($1/max)*100}')\""), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 5%- && hyprctl dismissnotify -1 && hyprctl notify 2 2000 0 \"brightness $(brightnessctl g | awk -v max=$(brightnessctl m) 'BEGIN{} {printf \"%.0f%%\", ($1/max)*100}')\""), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),        { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"),  { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"),  { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),    { locked = true })

-- Utilities function keys
hl.bind("XF86Calculator", hl.dsp.exec_cmd("gnome-calculator"), { locked = true })

-- ##############################
-- ### WINDOWS AND WORKSPACES ###
-- ##############################

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/ for more
-- See https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/ for workspace rules

-- Example window rule
-- hl.window_rule({ match = { class = "^(kitty)$", title = "^(kitty)$" }, float = true })

-- Ignore maximize requests from apps. You'll probably like this.
hl.window_rule({
    name           = "windowrule-1",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    name     = "windowrule-2",
    no_focus = true,
    match    = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
})

-- Emoji selector
hl.window_rule({
    name  = "emoji-selector",
    match = {class="it.mijorus.smile"},
    float = true,
    size  = { 325, 409 },
    move  = { "cursor_x-325/2", "cursor_y-409/2" },
})

-- Gapless cava visualizer
hl.window_rule({
    name             = "cava-g4music",
    match            = {class = "cava-g4music"},
    no_blur          = true,
    no_shadow        = true,
    no_dim           = true,
    border_size      = 0,
    rounding         = 0,
    no_initial_focus = true,
    no_focus         = true,
    opacity          = 2,  -- bypass inactive/active opacity multipliers
    float            = true,
    size             = { 454, 338 },
    move             = { 1123, 315 },
})

-- Free use cava visualizer
hl.window_rule({
    name             = "cava-free",
    match            = {class = "cava-free"},
    no_blur          = true,
    no_shadow        = true,
    no_dim           = true,
    border_size      = 0,
    rounding         = 0,
    no_initial_focus = true,
    opacity          = 2,  -- bypass inactive/active opacity multipliers
    float            = true,
    size             = { 390, 320 },
    move             = { 1022, 274 },
})
