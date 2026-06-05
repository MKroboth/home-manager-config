import { App, Astal, Gdk } from "astal/gtk3";
import { bind } from "astal";
import { showControlCenter } from "../state";

// Full-screen invisible eventbox: click-outside-to-close for the CC.
export default function CCCloser(monitor: Gdk.Monitor) {
  return (
    <window
      name="cc-closer"
      namespace="eww-cc-closer"
      gdkmonitor={monitor}
      application={App}
      visible={bind(showControlCenter)}
      anchor={
        Astal.WindowAnchor.TOP |
        Astal.WindowAnchor.BOTTOM |
        Astal.WindowAnchor.LEFT |
        Astal.WindowAnchor.RIGHT
      }
      layer={Astal.Layer.TOP}
    >
      <eventbox onClick={() => showControlCenter.set(false)} expand />
    </window>
  );
}
