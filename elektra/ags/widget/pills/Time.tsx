import { Variable } from "astal";
import { Gtk } from "astal/gtk3";
import GLib from "gi://GLib";

const TZ = "Europe/Vienna";

function makeClock(format: string) {
  const v = Variable("");
  const tick = () => {
    const dt = GLib.DateTime.new_now(GLib.TimeZone.new(TZ));
    v.set(dt.format(format) ?? "");
    return true;
  };
  tick();
  GLib.timeout_add_seconds(GLib.PRIORITY_DEFAULT, 30, tick);
  return v;
}

const hhmm = makeClock("%R");
const dayMonth = makeClock("%a %d %b");

function CalendarTooltip(): Gtk.Widget {
  const box = new Gtk.Box({ orientation: Gtk.Orientation.VERTICAL });
  box.get_style_context().add_class("tt-calendar");
  box.add(new Gtk.Calendar());
  box.show_all();
  return box;
}

export default function Time() {
  return (
    <box
      className="pill"
      spacing={6}
      setup={self => {
        self.set_has_tooltip(true);
        self.connect("query-tooltip", (_w, _x, _y, _kb, tip) => {
          tip.set_custom(CalendarTooltip());
          return true;
        });
      }}
    >
      <label className="pill-text" label={hhmm()} />
      <label className="pill-text-dim" label={dayMonth()} />
    </box>
  );
}
