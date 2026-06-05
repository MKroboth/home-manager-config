import { bind } from "astal";
import Hyprland from "gi://AstalHyprland";

const MAX = 80;

export default function WindowTitle() {
  const hypr = Hyprland.get_default();
  return (
    <box className="pill pill-subtle">
      <label
        className="pill-text"
        maxWidthChars={30}
        truncate
        label={bind(hypr, "focusedClient").as(c => {
          const t = c?.title ?? "...";
          return t.length > MAX ? `${t.slice(0, MAX - 3)}...` : t;
        })}
      />
    </box>
  );
}
