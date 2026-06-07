import GLib from "gi://GLib";
import { pollJson, pollLine } from "./proc";

const CFG = `${GLib.get_user_config_dir()}/ags`;

export type Weather = {
  temp_c: string; feels_like: string; desc: string; humidity: string; code: string;
};
export const weather = pollJson<Weather>(
  600_000,
  `${CFG}/scripts/get-weather`,
  { temp_c: "?", feels_like: "?", desc: "loading", humidity: "?", code: "0" },
);

export type Core = { id: number; usage: number };
export type Gpu = {
  busy: number;
  vram_total: number;
  vram_used: number;
  vram_pct: number;
};
export type Systats = {
  cores: Core[];
  core_rows: Core[][];
  temps: Record<string, number | null>;
  mem: { total_mib: number; used_mib: number; pct: number };
  gpu: Gpu | null;
};
export const systats = pollJson<Systats>(
  3_000,
  `${CFG}/scripts/get-systats-detail`,
  { cores: [], core_rows: [], temps: {}, mem: { total_mib: 0, used_mib: 0, pct: 0 }, gpu: null },
);

export const cpuTemperature = pollLine(2_000, `${CFG}/scripts/get-temperature`, "?°C");

export type Iface = {
  name: string; kind: string; state: string; speed: number;
  ip: string; rx: number; tx: number;
};
export type NetDetail = { ifaces: Iface[] };
export const netDetail = pollJson<NetDetail>(
  3_000,
  `${CFG}/scripts/get-network-detail`,
  { ifaces: [] },
);

// mako owns the notification bus name on this system, so AstalNotifd never
// sees anything. Poll mako directly for both currently-active and history.
// `makoctl list -j` returns the visible popups; `makoctl history -j` returns
// dismissed/expired notifications (kept in memory until mako restarts).
export type Notif = {
  id: number;
  app_name: string;
  app_icon: string | null;
  summary: string;
  body: string;
  urgency: "low" | "normal" | "critical";
  actions: Record<string, string>;
};
export const notifActive = pollJson<Notif[]>(2_000, "makoctl list -j", []);
export const notifHistory = pollJson<Notif[]>(2_000, "makoctl history -j", []);

// `makoctl mode` prints active modes one per line. We treat the "do-not-disturb"
// mode (defined in mako.nix with invisible=1) as the DND state. Polled cheaply
// since the value rarely changes.
export const makoModes = pollJson<string[]>(
  3_000,
  "makoctl mode | jq -R -s 'split(\"\\n\") | map(select(length > 0))'",
  [],
);
