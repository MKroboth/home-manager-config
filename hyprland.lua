local terminal = "kitty"
local menu = "wofi --show drun,run"
local browser = "librewolf"
local editor = "kitty nvim"
local notes = "obsidian --enable-features=UseOzonePlatform --ozone-platform=wayland"
local fileManager = "dolphin"
----------------- Configuration --------------------------------
hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 0,
		border_size = 2,
		col = {
			active_border = "rgba(33ccffee)",
			inactive_border = "rgba(595959aa)",
		},
		layout = "dwindle",
		allow_tearing = false
	},
	decoration = {
		rounding = 0,
		blur = {
			enabled = true,
			size = 3,
			passes = 1,
			vibrancy = 0.1696
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
	},
	binds = {
		workspace_center_on = 1
	},
	xwayland = {
		force_zero_scaling = true,
	},
	render = {
		cm_enabled = true,
	},
})

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

---------------------- Binds -------------------------------

hl.bind("SUPER + SHIFT + C", hl.dsp.window.close())
hl.bind("SUPER + SHIFT + Return", hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + P", hl.dsp.exec_cmd(menu))
hl.bind("SUPER + SHIFT + P", hl.dsp.window.pseudo())
hl.bind("SUPER + SHIFT + J", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

hl.bind("SUPER + H", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "down" }))


hl.bind("SUPER + Y", hl.dsp.exec_cmd("grimblast copy area"))

hl.bind("SUPER + mouse:272", hl.dsp.window.drag())
hl.bind("SUPER + mouse:273", hl.dsp.window.resize())

hl.bind("SUPER + X", hl.dsp.submap("execute"))

for workspace_id = 1, 10 do
	local workspace_key
	if workspace_id == 10 then
		workspace_key = 0
	else
		workspace_key = workspace_id
	end
	hl.bind("SUPER + " .. workspace_key, hl.dsp.focus({ workspace = workspace_id }))
	hl.bind("SUPER + SHIFT +" .. workspace_key, hl.dsp.window.move({ workspace = workspace_id, follow = false }))
end

hl.define_submap("execute", function()
	hl.bind("W", hl.dsp.exec_cmd(browser))
	hl.bind("E", hl.dsp.exec_cmd(editor))
	hl.bind("H", hl.dsp.exec_cmd(notes))
	hl.bind("F", hl.dsp.exec_cmd(fileManager))
	hl.bind("Escape", hl.dsp.submap("reset"))
	hl.bind("Return", hl.dsp.submap("reset"))
end)

hl.on("hyprland.start", function()
	hl.exec_cmd("systemctl --user start hyprland.target")
	hl.exec_cmd("systemctl --user start mako.service")
	hl.exec_cmd("systemctl --user start blueman-applet.service")
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("dex -a")
	hl.exec_cmd("~/.config/eww/scripts/start-eww")
	hl.exec_cmd("sleep 4; ~/bin/wallpapers.sh")
end)

local colorManagement = "srgb"
local fourKColorManagement = "srgb"
local sdrBrightness = 1.2
local sdrSaturation = 1.5

hl.monitor({
	output = "DP-3",
	mode = "2560x1440@166",
	position = "0x1440",
	scale = 1,
	cm = colorManagement,
})

hl.monitor({
	output = "DP-6",
	mode = "1920x1080@60",
	position = "0x0",
	scale = 0.75,
	cm = colorManagement,
})
hl.monitor({
	output = "DP-2",
	mode = "3840x2160@120",
	position = "2560x1440",
	scale = 1.5,
	vrr = 1,
	cm = fourKColorManagement,
	sdrbrightness = sdrBrightness,
	sdrsaturation = sdrSaturation,
	supports_wide_color = 1,
	supports_hdr = 1,
	sdr_min_luminance = 0.2,
	sdr_max_luminance = 80,
})
hl.monitor({
	output = "DP-5",
	mode = "2560x1440@166",
	position = "2560x0",
	scale = 1,
	cm = colorManagement,
})
hl.monitor({
	output = "DP-1",
	mode = "2560x1440@166",
	position = "5120x1440",
	scale = 1,
	cm = colorManagement,
})

hl.monitor({
	output = "DP-4",
	mode = "1920x1080@60",
	position = "5120x0",
	scale = 1,
	cm = colorManagement,
})
