import { bind, Variable } from "astal";
import Notifd from "gi://AstalNotifd";
import { showControlCenter } from "../../state";

export default function CCButton() {
  const notifd = Notifd.get_default();
  const dnd = Variable(false);
  // Astal notifd exposes dont-disturb directly.
  const dndBind = bind(notifd, "dontDisturb");

  return (
    <eventbox onClick={() => showControlCenter.set(!showControlCenter.get())}>
      <box className="pill pill-cc" spacing={4}>
        <label
          className="pill-icon"
          label={Variable.derive(
            [dndBind, bind(notifd, "notifications")],
            (d, n) => d ? "󰂛" : (n.length > 0 ? "󰂞" : "󰒓"),
          )()}
        />
        <label
          className="pill-text"
          visible={bind(notifd, "notifications").as(n => n.length > 0)}
          label={bind(notifd, "notifications").as(n => n.length > 0 ? `${n.length}` : "")}
        />
      </box>
    </eventbox>
  );
}
