import { App, Astal, Gtk, Gdk } from "astal/gtk3";
import { bind, execAsync, Variable } from "astal";
import Bluetooth from "gi://AstalBluetooth";
import Wp from "gi://AstalWp";
import Mpris from "gi://AstalMpris";

import { showControlCenter, nightlight, darkMode } from "../state";
import { toggleTheme } from "../lib/theme";
import { systats, cpuTemperature, weather, netDetail, notifActive, notifHistory, makoModes, type Notif } from "../lib/data";
import CCToggle from "./CCToggle";

function appIcon(name: string) {
  switch ((name ?? "").toLowerCase()) {
    case "vesktop": return "󰙯";
    case "kitty": return "";
    case "chrome": return "";
    case "librewolf": return "󰈹";
    case "steam": return "󰓓";
    default: return "󰍡";
  }
}

function Toggles() {
  const bt = Bluetooth.get_default();
  const dnd = bind(makoModes).as(m => m.includes("do-not-disturb"));

  const wiredUp = bind(netDetail).as(d => {
    const br = d.ifaces.find(i => i.kind === "bridge");
    return br?.state === "up";
  });

  return (
    <box className="cc-section" vertical spacing={8}>
      <box spacing={8} homogeneous>
        <CCToggle
          icon={wiredUp.as(up => up ? "󰈀" : "󰈂")}
          label="Network"
          sublabel={bind(netDetail).as(d => {
            const br = d.ifaces.find(i => i.kind === "bridge");
            return br?.state === "up" ? (br.ip ?? "Up") : "Off";
          })}
          active={wiredUp}
          onClick={() => {}}
        />
        <CCToggle
          icon={bind(bt, "isPowered").as(p => p ? "󰂯" : "󰂲")}
          label="Bluetooth"
          sublabel={Variable.derive(
            [bind(bt, "isPowered"), bind(bt, "devices")],
            (on, devs) => {
              const connected = devs.filter(d => d.connected);
              if (connected.length) return connected[0].alias ?? connected[0].name ?? "On";
              return on ? "On" : "Off";
            },
          )()}
          active={bind(bt, "isPowered")}
          onClick={() => { execAsync(["blueman-manager"]).catch(() => {}); }}
        />
      </box>
      <box spacing={8} homogeneous>
        <CCToggle
          icon={dnd.as(d => d ? "󰂛" : "󰂚")}
          label="Do Not Disturb"
          sublabel={dnd.as(d => d ? "On" : "Off")}
          active={dnd}
          onClick={() => {
            execAsync(["makoctl", "mode", "-t", "do-not-disturb"]).catch(() => {});
          }}
        />
        <CCToggle
          icon="󰖔"
          label="Night Light"
          sublabel={bind(nightlight).as(n => n ? "On" : "Off")}
          active={bind(nightlight)}
          onClick={() => {
            const next = !nightlight.get();
            nightlight.set(next);
            execAsync(["hyprctl", "hyprsunset", "temperature", next ? "2500" : "6000"]).catch(() => {});
          }}
        />
      </box>
      <box spacing={8} homogeneous>
        <CCToggle
          icon={bind(darkMode).as(d => d ? "󰽢" : "󰖨")}
          label="Theme"
          sublabel={bind(darkMode).as(d => d ? "Dark" : "Light")}
          active={bind(darkMode).as(d => !d)}
          onClick={toggleTheme}
        />
      </box>
    </box>
  );
}

function Media() {
  const mpris = Mpris.get_default();
  const player = Variable.derive([bind(mpris, "players")], ps => ps[0]);

  return (
    <box
      className={Variable.derive([player], p =>
        `cc-section cc-media ${p && p.playbackStatus !== Mpris.PlaybackStatus.STOPPED ? "" : "cc-media-hidden"}`,
      )()}
      visible={Variable.derive([player], p =>
        !!p && p.playbackStatus !== Mpris.PlaybackStatus.STOPPED,
      )()}
      vertical
      spacing={6}
    >
      <box spacing={10}>
        <label className="cc-media-icon" label="󰎆" />
        <box vertical hexpand>
          <label
            className="cc-media-title"
            halign={Gtk.Align.START}
            maxWidthChars={28}
            truncate
            label={Variable.derive([player], p => p?.title ?? "")()}
          />
          <label
            className="cc-media-artist"
            halign={Gtk.Align.START}
            maxWidthChars={32}
            truncate
            label={Variable.derive([player], p => p?.artist ?? "")()}
          />
        </box>
      </box>
      <box className="cc-media-controls" halign={Gtk.Align.CENTER} spacing={20}>
        <button className="cc-media-btn" onClicked={() => player.get()?.previous()} label="󰒮" />
        <button
          className="cc-media-btn cc-media-play"
          onClicked={() => player.get()?.play_pause()}
          label={Variable.derive([player], p =>
            p?.playbackStatus === Mpris.PlaybackStatus.PLAYING ? "󰏤" : "󰐊",
          )()}
        />
        <button className="cc-media-btn" onClicked={() => player.get()?.next()} label="󰒭" />
      </box>
    </box>
  );
}

function Sliders() {
  const speaker = Wp.get_default()?.audio.defaultSpeaker;
  return (
    <box className="cc-section" vertical spacing={10}>
      <box spacing={10}>
        <button
          className="cc-slider-icon"
          onClicked={() => { if (speaker) speaker.mute = !speaker.mute; }}
          label={speaker ? bind(speaker, "mute").as(m => m ? "󰸈" : "󰕾") : "󰕾"}
        />
        <slider
          className="glass-slider"
          hexpand
          min={0}
          max={100}
          value={speaker ? bind(speaker, "volume").as(v => v * 100) : 0}
          onDragged={({ value }) => { if (speaker) speaker.volume = value / 100; }}
        />
      </box>
    </box>
  );
}

// Mako keeps history in memory until restart and exposes no "forget single
// entry" CLI, so we filter the displayed history through a local hide-set
// and persist it in mako across restarts as well via a session marker file.
const hidden = Variable(new Set<number>());

function Notifications() {
  const combined = Variable.derive(
    [bind(notifActive), bind(notifHistory), bind(hidden)],
    (active, history, hide) => {
      const activeIds = new Set(active.map(n => n.id));
      const histClean = history
        .filter(n => !activeIds.has(n.id) && !hide.has(n.id))
        .slice(0, 25);
      return { active, history: histClean, total: active.length + histClean.length };
    },
  );

  function clearAll() {
    execAsync(["makoctl", "dismiss", "--all"]).catch(() => {});
    // Hide everything currently in history; mako-restart resets the set.
    const next = new Set(hidden.get());
    for (const n of notifHistory.get()) next.add(n.id);
    hidden.set(next);
  }

  function invoke(n: Notif) {
    const act = n.actions?.default ? "default" : Object.keys(n.actions ?? {})[0];
    if (!act) return;
    execAsync(["makoctl", "invoke", "-n", String(n.id), act]).catch(() => {});
  }

  function dismissActive(n: Notif) {
    execAsync(["makoctl", "dismiss", "-n", String(n.id)]).catch(() => {});
  }

  function hideHistory(n: Notif) {
    const next = new Set(hidden.get());
    next.add(n.id);
    hidden.set(next);
  }

  function row(n: Notif, isActive: boolean) {
    return (
      <eventbox onClick={() => invoke(n)}>
        <box className={`cc-notif-item ${isActive ? "cc-notif-active" : "cc-notif-history"}`} spacing={8}>
          <label className="cc-notif-app-icon" label={appIcon(n.app_name)} />
          <box vertical hexpand>
            <label
              className="cc-notif-summary"
              halign={Gtk.Align.START}
              maxWidthChars={30}
              truncate
              label={n.summary ?? ""}
            />
            <label
              className="cc-notif-body"
              halign={Gtk.Align.START}
              maxWidthChars={36}
              truncate
              visible={!!n.body}
              label={n.body ?? ""}
            />
          </box>
          <button
            className="cc-notif-close"
            onClicked={() => isActive ? dismissActive(n) : hideHistory(n)}
          >
            <label label="󰅖" />
          </button>
        </box>
      </eventbox>
    );
  }

  return (
    <box className="cc-section cc-notif-section" vertical spacing={6}>
      <box className="cc-notif-header">
        <label
          className="cc-notif-title"
          hexpand
          halign={Gtk.Align.START}
          label={combined(c => c.total > 0 ? `Notifications (${c.total})` : "Notifications")}
        />
        <button
          className="cc-notif-dismiss"
          visible={combined(c => c.total > 0)}
          onClicked={clearAll}
        >
          <label label="Clear" />
        </button>
      </box>
      <label
        className="cc-notif-empty"
        label="No notifications"
        visible={combined(c => c.total === 0)}
      />
      <scrollable
        hscroll={Gtk.PolicyType.NEVER}
        vscroll={Gtk.PolicyType.AUTOMATIC}
        propagateNaturalHeight
        maxContentHeight={260}
        visible={combined(c => c.total > 0)}
      >
        <box vertical spacing={4}>
          {combined(c => [
            ...c.active.map(n => row(n, true)),
            ...c.history.map(n => row(n, false)),
          ])}
        </box>
      </scrollable>
    </box>
  );
}

function QuickInfo() {
  const cpuAvg = Variable.derive([bind(systats)], s =>
    s.cores.length ? Math.round(s.cores.reduce((a, c) => a + c.usage, 0) / s.cores.length) : 0,
  );
  return (
    <box className="cc-section cc-bottom" spacing={8} homogeneous>
      <box className="cc-info-pill" spacing={4}>
        <label className="cc-info-icon" label="" />
        <label className="cc-info-text" label={cpuAvg(v => `${v}%`)} />
      </box>
      <box className="cc-info-pill" spacing={4}>
        <label className="cc-info-icon" label="" />
        <label className="cc-info-text" label={bind(systats).as(s => `${s.mem.pct}%`)} />
      </box>
      <box className="cc-info-pill" spacing={4}>
        <label className="cc-info-icon" label="" />
        <label className="cc-info-text" label={bind(cpuTemperature)} />
      </box>
      <box className="cc-info-pill" spacing={4}>
        <label className="cc-info-icon" label={bind(weather).as(w => weatherIcon(w.code))} />
        <label className="cc-info-text" label={bind(weather).as(w => `${w.temp_c}°`)} />
      </box>
    </box>
  );
}

function PowerActions() {
  return (
    <box className="cc-section cc-actions" spacing={8} homogeneous>
      <button
        className="cc-action-btn"
        onClicked={() => {
          showControlCenter.set(false);
          // loginctl routes through hypridle's lock_cmd, which spawns hyprlock.
          execAsync(["loginctl", "lock-session"]).catch(() => {});
        }}
      >
        <box spacing={8} halign={Gtk.Align.CENTER}>
          <label className="cc-action-icon" label="󰌾" />
          <label className="cc-action-label" label="Lock" />
        </box>
      </button>
    </box>
  );
}

function weatherIcon(code: string) {
  switch (code) {
    case "113": return "󰖙";
    case "116":
    case "119":
    case "122": return "󰖐";
    case "296":
    case "302": return "󰖗";
    case "395": return "󰖘";
    default: return "󰖐";
  }
}

export default function ControlCenter(monitor: Gdk.Monitor) {
  return (
    <window
      name="control-center"
      namespace="eww-control-center"
      gdkmonitor={monitor}
      application={App}
      visible={bind(showControlCenter)}
      anchor={Astal.WindowAnchor.BOTTOM | Astal.WindowAnchor.RIGHT}
      layer={Astal.Layer.OVERLAY}
      marginBottom={8}
      marginRight={8}
      keymode={Astal.Keymode.ON_DEMAND}
      onKeyPressEvent={(_, e) => {
        if (e.get_keyval()[1] === Gdk.KEY_Escape) showControlCenter.set(false);
      }}
    >
      <revealer
        revealChild={bind(showControlCenter)}
        transitionType={Gtk.RevealerTransitionType.SLIDE_UP}
        transitionDuration={300}
      >
        <box className="cc-panel" vertical spacing={10}>
          <Toggles />
          <Media />
          <Sliders />
          <Notifications />
          <QuickInfo />
          <PowerActions />
        </box>
      </revealer>
    </window>
  );
}
