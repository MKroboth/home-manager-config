import { App, Astal, Gtk, Gdk } from "astal/gtk3";
import { bind, Variable, timeout } from "astal";
import Wp from "gi://AstalWp";

// Transient OSD that pops in on volume / mute changes and auto-hides.
// One window per monitor; the visibility Variable is shared across them so
// every screen flashes the same pill at the same time.

type OsdKind = "volume" | "mute" | "mic";
type OsdPayload = { kind: OsdKind; value: number; muted: boolean };

const HIDE_AFTER_MS = 1500;

const visible = Variable(false);
const payload = Variable<OsdPayload>({ kind: "volume", value: 0, muted: false });

let hideToken = 0;
function show(p: OsdPayload) {
  payload.set(p);
  visible.set(true);
  const token = ++hideToken;
  timeout(HIDE_AFTER_MS, () => {
    if (token === hideToken) visible.set(false);
  });
}

// Wire up audio sources once at module load. Astal fires "notify::" on the
// initial property read too, so we swallow the first emission per source to
// avoid an OSD flash at startup.
let wired = false;
function wire() {
  if (wired) return;
  wired = true;
  const wp = Wp.get_default();
  const speaker = wp?.audio.defaultSpeaker;
  const mic = wp?.audio.defaultMicrophone;
  if (!speaker) return;

  let seenVol = false;
  let seenSpkMute = false;
  let seenMicMute = false;

  speaker.connect("notify::volume", () => {
    if (!seenVol) { seenVol = true; return; }
    show({ kind: "volume", value: speaker.volume, muted: speaker.mute });
  });
  speaker.connect("notify::mute", () => {
    if (!seenSpkMute) { seenSpkMute = true; return; }
    show({ kind: "mute", value: speaker.volume, muted: speaker.mute });
  });
  if (mic) {
    mic.connect("notify::mute", () => {
      if (!seenMicMute) { seenMicMute = true; return; }
      show({ kind: "mic", value: mic.volume, muted: mic.mute });
    });
  }
}

function icon(p: OsdPayload) {
  if (p.kind === "mic") return p.muted ? "󰍭" : "󰍬";
  if (p.muted || p.value <= 0.001) return "󰸈";
  if (p.value < 0.34) return "󰕿";
  if (p.value < 0.67) return "󰖀";
  return "󰕾";
}

function label(p: OsdPayload) {
  if (p.kind === "mic") return p.muted ? "Mic muted" : "Mic on";
  if (p.muted) return "Muted";
  return `${Math.round(p.value * 100)}%`;
}

export default function Osd(monitor: Gdk.Monitor) {
  wire();
  return (
    <window
      name="osd"
      namespace="osd"
      gdkmonitor={monitor}
      application={App}
      visible={bind(visible)}
      anchor={Astal.WindowAnchor.BOTTOM}
      marginBottom={120}
      layer={Astal.Layer.OVERLAY}
      keymode={Astal.Keymode.NONE}
    >
      <revealer
        revealChild={bind(visible)}
        transitionType={Gtk.RevealerTransitionType.CROSSFADE}
        transitionDuration={180}
      >
        <box className="osd" spacing={12}>
          <label className="osd-icon" label={bind(payload).as(icon)} />
          <box vertical valign={Gtk.Align.CENTER} spacing={4}>
            <label
              className="osd-text"
              halign={Gtk.Align.START}
              label={bind(payload).as(label)}
            />
            <levelbar
              className="osd-bar"
              widthRequest={180}
              heightRequest={6}
              value={bind(payload).as(p => (p.muted ? 0 : Math.min(1, p.value)))}
            />
          </box>
        </box>
      </revealer>
    </window>
  );
}
