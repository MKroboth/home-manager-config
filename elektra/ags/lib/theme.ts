import { execAsync } from "astal";
import GLib from "gi://GLib";
import { darkMode } from "../state";

const CFG = `${GLib.get_user_config_dir()}/ags`;

export function applyTheme(mode: "dark" | "light") {
  darkMode.set(mode === "dark");
  execAsync(["bash", "-c", `${CFG}/scripts/apply-theme ${mode}`]).catch(() => {});
  execAsync(["bash", "-c", `$HOME/bin/wallpapers.sh ${mode}`]).catch(() => {});
}

export function toggleTheme() {
  applyTheme(darkMode.get() ? "light" : "dark");
}
