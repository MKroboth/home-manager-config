import { Variable } from "astal";
import GLib from "gi://GLib";

// Global UI state — replaces eww defvars.
export const showControlCenter = Variable(false);
export const showScreenSettings = Variable(false);

const themeCache = `${GLib.get_user_cache_dir()}/eww-theme`;
const initialMode = (() => {
  try {
    const [ok, data] = GLib.file_get_contents(themeCache);
    if (ok) return new TextDecoder().decode(data).trim() || "dark";
  } catch (_) {}
  return "dark";
})();

export const darkMode = Variable(initialMode !== "light");
export const nightlight = Variable(false);
