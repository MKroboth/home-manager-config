import { App, Astal, Gtk, Gdk } from "astal/gtk3";
import Workspaces from "./pills/Workspaces";
import WindowTitle from "./pills/WindowTitle";
import Weather from "./pills/Weather";
import Audio from "./pills/Audio";
import Network from "./pills/Network";
import Systats from "./pills/Systats";
import Time from "./pills/Time";
import CCButton from "./pills/CCButton";
import Tray from "./pills/Tray";

export default function Bar(monitor: Gdk.Monitor) {
  return (
    <window
      className="bar-glass"
      name="bar"
      namespace="bar"
      gdkmonitor={monitor}
      application={App}
      anchor={Astal.WindowAnchor.BOTTOM | Astal.WindowAnchor.LEFT | Astal.WindowAnchor.RIGHT}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      layer={Astal.Layer.TOP}
      marginBottom={8}
    >
      <centerbox>
        <box halign={Gtk.Align.START} spacing={8}>
          <Workspaces />
        </box>
        <box halign={Gtk.Align.CENTER} spacing={6}>
          <WindowTitle />
        </box>
        <box halign={Gtk.Align.END} spacing={4}>
          <Weather />
          <Audio />
          <Network />
          <Systats />
          <Time />
          <CCButton />
          <Tray />
        </box>
      </centerbox>
    </window>
  );
}
