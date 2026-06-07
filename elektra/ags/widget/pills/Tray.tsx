import { bind } from "astal";
import { Gtk, Gdk } from "astal/gtk3";
import Tray from "gi://AstalTray";

export default function TrayPill() {
  const tray = Tray.get_default();
  return (
    <box className="pill">
      {bind(tray, "items").as(items =>
        items.map(item => (
          <menubutton
            className="tray-item"
            tooltipMarkup={bind(item, "tooltipMarkup")}
            usePopover={false}
            actionGroup={bind(item, "actionGroup").as(g => ["dbusmenu", g])}
            menuModel={bind(item, "menuModel")}
          >
            <icon gIcon={bind(item, "gicon")} />
          </menubutton>
        )),
      )}
    </box>
  );
}
