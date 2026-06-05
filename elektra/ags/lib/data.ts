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
export type Systats = {
  cores: Core[];
  core_rows: Core[][];
  temps: Record<string, number | null>;
  mem: { total_mib: number; used_mib: number; pct: number };
};
export const systats = pollJson<Systats>(
  3_000,
  `${CFG}/scripts/get-systats-detail`,
  { cores: [], core_rows: [], temps: {}, mem: { total_mib: 0, used_mib: 0, pct: 0 } },
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
