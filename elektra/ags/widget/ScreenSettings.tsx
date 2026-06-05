import { App, Astal, Gtk, Gdk } from "astal/gtk3";
import { bind, execAsync } from "astal";
import { showScreenSettings } from "../state";

export default function ScreenSettings(monitor: Gdk.Monitor) {
  return (
    <window
      name="screen-settings"
      namespace="eww-screen-settings"
      gdkmonitor={monitor}
      application={App}
      visible={bind(showScreenSettings)}
      anchor={Astal.WindowAnchor.BOTTOM | Astal.WindowAnchor.RIGHT}
      marginRight={400}
    >
      <revealer
        revealChild={bind(showScreenSettings)}
        transitionType={Gtk.RevealerTransitionType.SLIDE_UP}
      >
        <box className="glass-popup" vertical spacing={8}>
          <box spacing={8}>
            <label className="popup-label" label="Night Mode" />
            <switch
              onActivate={({ active }) =>
                execAsync([
                  "hyprctl", "hyprsunset", "temperature", active ? "2500" : "6000",
                ]).catch(() => {})
              }
            />
          </box>
          <box spacing={8}>
            <label className="popup-label" label="Brightness" />
            <slider
              className="glass-slider"
              min={10}
              max={100}
              onDragged={({ value }) =>
                execAsync(["hyprctl", "hyprsunset", "gamma", String(value)]).catch(() => {})
              }
            />
          </box>
        </box>
      </revealer>
    </window>
  );
}
