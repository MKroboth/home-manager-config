import { bind, Variable } from "astal";
import { Gtk } from "astal/gtk3";
import { systats, cpuTemperature, type Core } from "../../lib/data";

const cpuAvg = Variable.derive([bind(systats)], s => {
  if (!s.cores.length) return 0;
  return Math.round(s.cores.reduce((a, c) => a + c.usage, 0) / s.cores.length);
});

function cell(c: Core) {
  const cls = c.usage >= 75 ? "high" : c.usage >= 40 ? "mid" : c.usage >= 10 ? "low" : "idle";
  const text = c.usage < 10 ? ` ${c.usage}` : `${c.usage}`;
  return (
    <box className={`tt-cpu-cell ${cls}`}>
      <label label={text} />
    </box>
  );
}

function SystatsTooltip() {
  return (
    <box className="tt-box" vertical spacing={10}>
      <box spacing={12}>
        <label className="tt-title" halign={Gtk.Align.START} hexpand label="CPU" />
        <label className="tt-meta" label={bind(cpuAvg).as(a => `avg ${a}%`)} />
      </box>
      <box className="tt-cpu-grid" vertical spacing={3}>
        {bind(systats).as(s =>
          s.core_rows.map(row => (
            <box spacing={3}>{row.map(c => cell(c))}</box>
          )),
        )}
      </box>

      <box spacing={12}>
        <label className="tt-title" halign={Gtk.Align.START} hexpand label="GPU" />
        <label className="tt-meta" label={bind(systats).as(s => s.gpu ? `busy ${s.gpu.busy}%` : "—")} />
      </box>
      <label halign={Gtk.Align.START} className="tt-mono"
             label={bind(systats).as(s => {
               if (!s.gpu) return "VRAM —";
               const used = (s.gpu.vram_used / 1073741824).toFixed(1);
               const tot  = (s.gpu.vram_total / 1073741824).toFixed(1);
               return `VRAM  ${used} / ${tot} GiB   (${s.gpu.vram_pct}%)`;
             })} />

      <label className="tt-title" halign={Gtk.Align.START} label="Temperatures" />
      <box vertical spacing={2}>
        <label halign={Gtk.Align.START} className="tt-mono"
               label={bind(systats).as(s => {
                 const t = s.temps;
                 return `CPU   Tctl ${num(t.tctl, 1)}°  Tccd1 ${num(t.tccd1, 1)}°  Tccd2 ${num(t.tccd2, 1)}°`;
               })} />
        <label halign={Gtk.Align.START} className="tt-mono"
               label={bind(systats).as(s => {
                 const t = s.temps;
                 return `GPU   edge ${num(t.gpu_edge, 0)}°  junction ${num(t.gpu_junction, 0)}°  mem ${num(t.gpu_mem, 0)}°`;
               })} />
        <label halign={Gtk.Align.START} className="tt-mono"
               label={bind(systats).as(s => {
                 const t = s.temps;
                 return `NIC   PHY ${num(t.nic_phy, 0)}°  MAC ${num(t.nic_mac, 0)}°`;
               })} />
      </box>

      <label className="tt-title" halign={Gtk.Align.START} label="Memory" />
      <label halign={Gtk.Align.START} className="tt-mono"
             label={bind(systats).as(s =>
               `${(s.mem.used_mib / 1024).toFixed(1)} / ${(s.mem.total_mib / 1024).toFixed(1)} GiB   (${s.mem.pct}%)`,
             )} />
    </box>
  );
}

function num(v: number | null | undefined, digits: number) {
  return typeof v === "number" ? v.toFixed(digits) : "—";
}

export default function SystatsPill() {
  return (
    <box
      className="pill"
      spacing={8}
      setup={self => {
        self.set_has_tooltip(true);
        self.connect("query-tooltip", (_w, _x, _y, _kb, tip) => {
          tip.set_custom(SystatsTooltip() as unknown as Gtk.Widget);
          return true;
        });
      }}
    >
      <box spacing={3}>
        <label className="pill-icon-dim" label="" />
        <label className="pill-text" label={bind(cpuAvg).as(a => `${a}%`)} />
      </box>
      <box spacing={3}>
        <label className="pill-icon-dim" label="󰍛" />
        <label className="pill-text" label={bind(systats).as(s => `${s.mem.pct}%`)} />
      </box>
      <box spacing={3}>
        <label className="pill-icon-dim" label="󰢮" />
        <label className="pill-text" label={bind(systats).as(s => `${s.gpu?.busy ?? 0}%`)} />
      </box>
      <box spacing={3}>
        <label className="pill-icon-dim" label="" />
        <label className="pill-text" label={bind(systats).as(s => `${s.gpu?.vram_pct ?? 0}%`)} />
      </box>
      <box spacing={3}>
        <label className="pill-icon-dim" label="" />
        <label className="pill-text" label={bind(cpuTemperature)} />
      </box>
    </box>
  );
}
