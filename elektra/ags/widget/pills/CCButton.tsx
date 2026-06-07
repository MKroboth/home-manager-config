import { bind, Variable } from "astal";
import { showControlCenter } from "../../state";
import { notifActive, makoModes } from "../../lib/data";

export default function CCButton() {
  // mako owns the notification bus, so DND state lives in `makoctl mode` and
  // active popups come from `makoctl list -j` — not AstalNotifd.
  const dnd = bind(makoModes).as(m => m.includes("do-not-disturb"));
  const count = bind(notifActive).as(n => n.length);

  return (
    <eventbox onClick={() => showControlCenter.set(!showControlCenter.get())}>
      <box className="pill pill-cc" spacing={4}>
        <label
          className="pill-icon"
          label={Variable.derive(
            [dnd, count],
            (d, n) => d ? "󰂛" : (n > 0 ? "󰂞" : "󰒓"),
          )()}
        />
        <label
          className="pill-text"
          visible={count.as(n => n > 0)}
          label={count.as(n => n > 0 ? `${n}` : "")}
        />
      </box>
    </eventbox>
  );
}
