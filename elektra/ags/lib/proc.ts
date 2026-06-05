import { Variable, exec, execAsync } from "astal";
import GLib from "gi://GLib";

// Poll an external script at a fixed interval and parse JSON.
export function pollJson<T>(intervalMs: number, cmd: string, initial: T): Variable<T> {
  const v = Variable(initial);
  const tick = () => {
    execAsync(["bash", "-c", cmd])
      .then(out => {
        try { v.set(JSON.parse(out as string) as T); }
        catch (_) { /* keep previous */ }
      })
      .catch(() => {});
    return true;
  };
  tick();
  GLib.timeout_add(GLib.PRIORITY_DEFAULT, intervalMs, tick);
  return v;
}

// Poll a command that returns a single string line.
export function pollLine(intervalMs: number, cmd: string, initial = ""): Variable<string> {
  const v = Variable(initial);
  const tick = () => {
    execAsync(["bash", "-c", cmd])
      .then(out => v.set((out as string).trim()))
      .catch(() => {});
    return true;
  };
  tick();
  GLib.timeout_add(GLib.PRIORITY_DEFAULT, intervalMs, tick);
  return v;
}

export function execSync(cmd: string): string {
  try { return exec(["bash", "-c", cmd]); }
  catch (_) { return ""; }
}
