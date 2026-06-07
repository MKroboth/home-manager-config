import { bind, Variable } from "astal";
import Hyprland from "gi://AstalHyprland";

const WORKSPACE_COUNT = 6;
const WORKSPACE_IDS = Array.from({ length: WORKSPACE_COUNT }, (_, i) => i + 1);

export default function Workspaces() {
  const hypr = Hyprland.get_default();

  return (
    <eventbox
      className="workspaces-widget"
      onScroll={(_, e) => {
        const cur = hypr.get_focused_workspace()?.id ?? 1;
        const target = Math.max(1, Math.min(WORKSPACE_COUNT, cur + (e.delta_y > 0 ? 1 : -1)));
        hypr.dispatch("workspace", String(target));
      }}
    >
      <box spacing={6}>
        {WORKSPACE_IDS.map(id => {
          const count = Variable.derive(
            [bind(hypr, "workspaces")],
            ws => ws.find(w => w.id === id)?.clients?.length ?? 0,
          );
          const current = Variable.derive(
            [bind(hypr, "focusedWorkspace")],
            f => f?.id === id,
          );
          const fullscreen = Variable.derive(
            [bind(hypr, "workspaces")],
            ws => ws.find(w => w.id === id)?.hasFullscreen ?? false,
          );

          const itemCls = Variable.derive([current, fullscreen], (c, f) => {
            const cls = ["workspace-item"];
            if (c) cls.push("current");
            if (f) cls.push("fullscreen");
            return cls.join(" ");
          });
          const numCls = Variable.derive([current, count], (cur, n) => {
            const cls = ["workspace-num"];
            if (cur) cls.push("current");
            else if (n === 0) cls.push("empty");
            return cls.join(" ");
          });

          return (
            <eventbox onClick={() => hypr.dispatch("workspace", String(id))}>
              <box className={itemCls()} spacing={2}>
                <label className={numCls()} label={String(id)} />
                <label
                  className="workspace-count"
                  visible={bind(count).as(n => n > 0)}
                  label={bind(count).as(n => String(n))}
                />
              </box>
            </eventbox>
          );
        })}
      </box>
    </eventbox>
  );
}
