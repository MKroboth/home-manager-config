import { bind } from "astal";
import { Gtk } from "astal/gtk3";
import { netDetail, type Iface } from "../../lib/data";

function rate(b: number) {
  if (b >= 1_048_576) return `${(b / 1_048_576).toFixed(1)} MB/s`;
  if (b >= 1024) return `${(b / 1024).toFixed(1)} KB/s`;
  return `${b} B/s`;
}

function IfaceRow({ iface }: { iface: Iface }) {
  const up = iface.state === "up";
  return (
    <box className="tt-iface-row" vertical spacing={1}>
      <box spacing={10}>
        <label className={`tt-dot ${up ? "up" : "down"}`} label="●" />
        <label
          className="tt-iface-name"
          halign={Gtk.Align.START}
          hexpand
          label={`${iface.name}  ${iface.kind}`}
        />
        <label
          className="tt-iface-meta"
          label={up ? (iface.speed > 0 ? `${iface.speed} Mb/s` : "up") : "down"}
        />
      </box>
      {up && (
        <box className="tt-iface-sub" spacing={12}>
          <label halign={Gtk.Align.START} hexpand label={iface.ip ?? ""} />
          <label label={`↓ ${rate(iface.rx)}`} />
          <label label={`↑ ${rate(iface.tx)}`} />
        </box>
      )}
    </box>
  );
}

function NetworkTooltip() {
  return (
    <box className="tt-box" vertical spacing={8}>
      <label className="tt-title" halign={Gtk.Align.START} label="Network" />
      <box vertical spacing={8}>
        {bind(netDetail).as(d => d.ifaces.map(iface => <IfaceRow iface={iface} />))}
      </box>
    </box>
  );
}

export default function NetworkPill() {
  return (
    <box
      className="pill"
      spacing={4}
      setup={self => {
        self.set_has_tooltip(true);
        self.connect("query-tooltip", (_w, _x, _y, _kb, tip) => {
          tip.set_custom(NetworkTooltip() as unknown as Gtk.Widget);
          return true;
        });
      }}
    >
      <label
        className="pill-icon"
        label={bind(netDetail).as(d => {
          const br = d.ifaces.find(i => i.kind === "bridge");
          return br?.state === "up" ? "󰈀" : "󰈂";
        })}
      />
      <label
        className="pill-text"
        label={bind(netDetail).as(d => {
          const br = d.ifaces.find(i => i.kind === "bridge");
          return br?.state === "up" ? (br.ip ?? "up") : "Down";
        })}
      />
    </box>
  );
}
