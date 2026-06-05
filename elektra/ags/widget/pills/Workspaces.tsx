import { bind, Variable } from "astal";
import Hyprland from "gi://AstalHyprland";

const MONITOR_COLOR_COUNT = 3;
const WORKSPACE_COUNT = 6;
const WORKSPACE_IDS = Array.from({ length: WORKSPACE_COUNT }, (_, i) => i + 1);

export default function Workspaces() {
  const hypr = Hyprland.get_default();

  // Per-monitor active workspace map → which colour border each dot gets.
  const monitorActive = Variable<number[]>([]);
  const refreshMonitors = () => {
    monitorActive.set(hypr.get_monitors().map(m => m.get_active_workspace()?.id ?? 0));
  };
  refreshMonitors();
  hypr.connect("notify::focused-workspace", refreshMonitors);
  hypr.connect("notify::monitors", refreshMonitors);

  return (
    <eventbox
      className="workspaces-widget"
      onScroll={(_, e) => {
        const cur = hypr.get_focused_workspace()?.id ?? 1;
        const target = Math.max(1, Math.min(WORKSPACE_COUNT, cur + (e.delta_y > 0 ? 1 : -1)));
        hypr.dispatch("workspace", String(target));
      }}
    >
      <box spacing={4}>
        {WORKSPACE_IDS.map(id => {
          const cls = Variable.derive(
            [bind(hypr, "workspaces"), bind(hypr, "focusedWorkspace"), bind(monitorActive)],
            (workspaces, focused, monActive) => {
              const ws = workspaces.find(w => w.id === id);
              const occupied = (ws?.clients?.length ?? 0) > 0;
              const current = focused?.id === id;
              const classes = ["workspace-dot"];
              if (current) classes.push("current");
              if (occupied) classes.push("occupied");
              for (let m = 0; m < MONITOR_COLOR_COUNT; m++) {
                if (monActive[m] === id) classes.push(`monitor-${m}`);
              }
              return classes.join(" ");
            },
          );
          return (
            <eventbox onClick={() => hypr.dispatch("workspace", String(id))}>
              <box className="workspace-entry">
                <label label="●" className={cls()} />
              </box>
            </eventbox>
          );
        })}
      </box>
    </eventbox>
  );
}
