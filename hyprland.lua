local terminal = "kitty"
local menu = "wofi --show drun,run"
local browser = "librewolf"
local editor = "kitty nvim"
local notes = "obsidian --enable-features=UseOzonePlatform --ozone-platform=wayland"
local fileManager = "dolphin"

----------------- Environment ----------------------------------
-- Mirror the QT settings that home-manager writes into hm-session-vars.sh,
-- so Hyprland-spawned Qt apps (which may not inherit a shell-sourced env)
-- pick up Kvantum + behave as if Plasma were the active session.
--
-- The KDE_* / XDG_CURRENT_DESKTOP=KDE bits are critical: KColorScheme and
-- Kirigami check these to decide they're on a KDE session and to enable
-- the Plasma colour-scheme code path. Without them, KFileItemDelegate /
-- KToolBar / KCM/QML widgets render dark-on-light defaults even when our
-- kdeglobals palette is correct, because QStyleHints::colorScheme() stays
-- Unknown on a bare Hyprland session.
hl.env("QT_STYLE_OVERRIDE", "kvantum")
hl.env("XDG_CURRENT_DESKTOP", "KDE:Hyprland")
hl.env("KDE_SESSION_VERSION", "6")
hl.env("KDE_FULL_SESSION", "true")

----------------- Theme-driven borders --------------------------
-- Read the persisted light/dark mode so `hyprctl reload` rebuilds the
-- borders for the active theme instead of snapping back to dark. The
-- runtime override lives in apply-theme via `hyprctl keyword`.
local function read_theme_mode()
	local f = io.open(os.getenv("HOME") .. "/.cache/eww-theme", "r")
	if not f then return "dark" end
	local mode = f:read("*l")
	f:close()
	return mode == "light" and "light" or "dark"
end

local theme_mode = read_theme_mode()
local active_border = theme_mode == "light"
    and "rgba(3a6dd1cc)"
    or "rgba(7aafffcc)"
local inactive_border = theme_mode == "light"
    and "rgba(1a1a2230)"
    or "rgba(ffffff20)"

----------------- Configuration --------------------------------
hl.config({
	general = {
		gaps_in = 6,
		gaps_out = 10,
		border_size = 1,
		col = {
			active_border = active_border,
			inactive_border = inactive_border,
		},
		layout = "dwindle",
		allow_tearing = false
	},
	decoration = {
		rounding = 14,
		rounding_power = 2.5,
		active_opacity = 1.0,
		inactive_opacity = 0.92,
		dim_inactive = true,
		dim_strength = 0.15,
		shadow = {
			enabled = true,
			range = 24,
			render_power = 3,
			color = 0x55000000,
		},
		blur = {
			enabled = true,
			size = 12,
			passes = 4,
			vibrancy = 0.22,
			new_optimizations = true,
			xray = false,
			popups = true,
			popups_ignorealpha = 0.2,
		},
	},
	dwindle = {
		preserve_split = true,
	},
	gestures = {},
	input = {
		kb_layout = "us",
		kb_options = "caps:escape,compose:menu",
		follow_mouse = 1,
		sensitivity = 0,
		touchpad = {
			natural_scroll = false,
		},
		numlock_by_default = true,
	},
	binds = {
		workspace_center_on = 1
	},
	xwayland = {
		force_zero_scaling = true,
	},
	cursor = {
		no_hardware_cursors = 1, -- HW cursors bypass color management in HDR; force SW cursors
	},
	render = {
		cm_enabled = true,
		cm_auto_hdr = 2,
	},
	quirks = {
		prefer_hdr = 1,
	},
})

--------------------- Layer Rules -------------------------

-- Liquid-glass blur for all shell surfaces.
local glass_layers = {
	"^bar$",
	"^eww-control-center$", -- AGS reuses the eww- namespaces for Hyprland rule continuity.
	"^eww-screen-settings$",
	"^eww-cc-closer$",
	"^notifications$", -- mako
	"^wofi$",
}
for _, ns in ipairs(glass_layers) do
	hl.layer_rule({
		name = "glass blur: " .. ns,
		match = { namespace = ns },
		blur = true,
		blur_popups = true,
		ignore_alpha = 0.2,
	})
end

--------------------- Window Rules ------------------------

hl.window_rule({
	name = "Fix intellij focus issues when dialogs are opened or closed",
	match = { class = "^(jetbrains-.*)$", title = "^(splash)$", float = true },
	center = true,
	no_focus = true,
	border_size = 0
})

hl.window_rule({
	name = "Center popups/find windows",
	match = { class = "^(jetbrains-.*)$", title = "^( )$", float = true },
	center = true,
	stay_focused = true,
	no_focus = true,
	border_size = 0
})

local nontransparent_windows = { "^(.*)(YouTube)(.*)$", "^FINAL FANTASY XIV$" }
for _, window_title in pairs(nontransparent_windows) do
	hl.window_rule({
		name = "Disable transparency for specified windows",
		match = { title = window_title },
		opacity = 1
	})
end


hl.window_rule({
	name = "Fix Steam",
	match = { class = "^(steam)", title = "^()" },
	min_size = { 1, 1 },
	stay_focused = true
})

hl.window_rule({
	name = "Mark Steam games as `game` type applications",
	match = { class = "^(steam_app_)(.*)$" },
	content = "game"
})

-- ── Liquid-glass per-app opacity ──
-- Combined with decoration.active_opacity / inactive_opacity globally.
local glass_apps = {
	{ class = "^(kitty)$",               opacity = 0.82 },
	{ class = "^(org\\.kde\\.dolphin)$", opacity = 0.92 },
	{ class = "^(dolphin)$",             opacity = 0.92 },
	{ class = "^(obsidian)$",            opacity = 0.92 },
	{ class = "^(vesktop)$",             opacity = 0.92 },
	{ class = "^(librewolf)$",           opacity = 0.94 },
	{ class = "^(thunderbird)$",         opacity = 0.94 },
}
for _, rule in ipairs(glass_apps) do
	hl.window_rule({
		name = "glass opacity: " .. rule.class,
		match = { class = rule.class },
		opacity = rule.opacity,
	})
end

--------------------- Workspace Rules ---------------------
-- One workspace pinned per monitor (6 monitors, 6 workspaces).
-- 4K (DP-2) uses master; 1080p (DP-4, DP-6) use scrolling; 1440p stay on dwindle.
local workspaces = {
	{ id = 1, monitor = "DP-2", layout = "master" }, -- 4K, primary
	{ id = 2, monitor = "DP-6", layout = "scrolling" }, -- 1080p top-left
	{ id = 3, monitor = "DP-5" },                -- 1440p top-middle
	{ id = 4, monitor = "DP-4", layout = "scrolling" }, -- 1080p top-right
	{ id = 5, monitor = "DP-3" },                -- 1440p bottom-left
	{ id = 6, monitor = "DP-1" },                -- 1440p bottom-right
}
for _, ws in ipairs(workspaces) do
	local rule = {
		workspace = tostring(ws.id),
		monitor = ws.monitor,
		default = true,
		persistent = true,
	}
	if ws.layout then rule.layout = ws.layout end
	hl.workspace_rule(rule)
end

---------------------- Binds -------------------------------

hl.bind("SUPER + SHIFT + C", hl.dsp.window.close())
hl.bind("SUPER + SHIFT + Return", hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + P", hl.dsp.exec_cmd(menu))
hl.bind("SUPER + SHIFT + P", hl.dsp.window.pseudo())
hl.bind("SUPER + SHIFT + J", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind("SUPER + SHIFT + T", hl.dsp.window.float())

hl.bind("SUPER + H", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "down" }))

hl.bind("SUPER + mouse_up", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + mouse_down", hl.dsp.focus({ direction = "right" }))


hl.bind("SUPER + Y", hl.dsp.exec_cmd("grimblast copy area"))

hl.bind("SUPER + mouse:272", hl.dsp.window.drag())
hl.bind("SUPER + mouse:273", hl.dsp.window.resize())

hl.bind("SUPER + X", hl.dsp.submap("execute"))

hl.bind("SUPER + F12", hl.dsp.exec_cmd("pkill -f 'ags run'"))

-- XF86 multimedia keys. `repeating = true` lets volume keys auto-fire while
-- held; `locked = true` lets them fire while the screen is locked.
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true, locked = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86AudioPlay",        hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause",       hl.dsp.exec_cmd("playerctl pause"), { locked = true })
hl.bind("XF86AudioNext",        hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev",        hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioStop",        hl.dsp.exec_cmd("playerctl stop"), { locked = true })
for workspace_id = 1, 6 do
	hl.bind("SUPER + " .. workspace_id, hl.dsp.focus({ workspace = workspace_id }))
	hl.bind("SUPER + SHIFT +" .. workspace_id, hl.dsp.window.move({ workspace = workspace_id, follow = false }))
end

hl.define_submap("execute", "reset", function()
	hl.bind("W", hl.dsp.exec_cmd(browser))
	hl.bind("E", hl.dsp.exec_cmd(editor))
	hl.bind("H", hl.dsp.exec_cmd(notes))
	hl.bind("F", hl.dsp.exec_cmd(fileManager))
	hl.bind("Escape", hl.dsp.submap("reset"))
	hl.bind("Return", hl.dsp.submap("reset"))
end)

----------------- Startup ----------------------------
hl.on("hyprland.start", function()
	hl.exec_cmd("systemctl --user start hyprland.target")
	hl.exec_cmd("systemctl --user start mako.service")
	hl.exec_cmd("systemctl --user start blueman-applet.service")
	hl.exec_cmd("awww-daemon")
	hl.exec_cmd("dex -a")
	hl.exec_cmd("~/.config/ags/scripts/start-ags")
	hl.exec_cmd("sleep 4; ~/bin/wallpapers.sh \"$(cat ~/.cache/eww-theme 2>/dev/null || echo dark)\"")
end)


------------------ Monitors ---------------------------

local colorManagement = "auto"
local sdrBrightness = 2.2
local sdrSaturation = 1.0

-- Real-HDR monitors (DisplayHDR 600+). SDR luminance vars keep SDR content
-- from looking dim/washed when the panel is in HDR mode.
local hdrCommon = {
	cm = "srgb", -- BT.2020 primaries; `hdredid` is poorly supported in current Hyprland and looks identical here
	bitdepth = 10,
	supports_wide_color = 1,
	supports_hdr = 1,
	sdrbrightness = sdrBrightness,
	sdrsaturation = sdrSaturation,
	sdr_min_luminance = 0.2,
	sdr_max_luminance = 80,
}

-- 10-bit sRGB for panels that EDID-claim wide gamut / HDR but don't really
-- cover it. `cm = "wide"` over-saturates content because Hyprland renders to
-- BT.2020 and the panel can't actually reach those primaries.
local wideCommon = {
	cm = "srgb",
	bitdepth = 10,
}

local function applyDefaults(opts, defaults)
	for k, v in pairs(defaults) do
		if opts[k] == nil then opts[k] = v end
	end
	hl.monitor(opts)
end

local function hdrMonitor(opts) applyDefaults(opts, hdrCommon) end
local function wideMonitor(opts) applyDefaults(opts, wideCommon) end

wideMonitor({
	-- bottom left
	output = "DP-3",
	mode = "2560x1440@166",
	position = "0x1440",
	scale = 1,
})

hl.monitor({
	-- top left
	output = "DP-6",
	mode = "1920x1080@60",
	position = "0x0",
	scale = 0.75,
	cm = colorManagement,
})

hdrMonitor({
	output = "DP-2",
	mode = "3840x2160@120",
	position = "2560x1440",
	scale = 1.5,
	vrr = 1,
})

wideMonitor({
	output = "DP-5",
	mode = "2560x1440@166",
	position = "2560x0",
	scale = 1,
})

wideMonitor({
	output = "DP-1",
	mode = "2560x1440@166",
	position = "5120x1440",
	scale = 1,
})

hl.monitor({
	output = "DP-4",
	mode = "1920x1080@60",
	position = "5120x0",
	scale = 0.75,
	cm = colorManagement,
})
