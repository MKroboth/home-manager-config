import { App, Gdk } from "astal/gtk3";
import Hyprland from "gi://AstalHyprland";
import style from "./style.scss";
import Bar from "./widget/Bar";
import ControlCenter from "./widget/ControlCenter";
import CCCloser from "./widget/CCCloser";
import ScreenSettings from "./widget/ScreenSettings";

// Hyprland connector name of the monitor that should host the bar.
// `hyprctl monitors -j | jq '.[].name'` lists the candidates.
const TARGET_MONITOR = "DP-5";

// GTK3's Gdk.Monitor doesn't expose the connector name directly, so we
// look up the Hyprland monitor by name and then find the Gdk monitor at
// the same screen position. This survives monitor reordering by Gdk.
function resolveMonitor(connector: string): Gdk.Monitor {
  const gdkMons = App.get_monitors();
  const hypr = Hyprland.get_default();
  const hyprMon = hypr.get_monitors().find(m => m.name === connector);
  if (!hyprMon) {
    console.log(`[ags] monitor ${connector} not found, falling back to monitor 0`);
    return gdkMons[0];
  }
  const match = gdkMons.find(g => {
    const r = g.get_geometry();
    return r.x === hyprMon.x && r.y === hyprMon.y;
  });
  return match ?? gdkMons[0];
}

App.start({
  css: style,
  main() {
    const monitor = resolveMonitor(TARGET_MONITOR);
    Bar(monitor);
    ControlCenter(monitor);
    CCCloser(monitor);
    ScreenSettings(monitor);
  },
});
