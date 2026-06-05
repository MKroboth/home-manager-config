import { bind } from "astal";
import Wp from "gi://AstalWp";

export default function Audio() {
  const speaker = Wp.get_default()?.audio.defaultSpeaker;
  if (!speaker) return <box />;

  return (
    <eventbox
      onClick={() => { speaker.mute = !speaker.mute; }}
      onScroll={(_, e) => {
        const step = 0.02;
        speaker.volume = Math.max(0, Math.min(1, speaker.volume + (e.delta_y < 0 ? step : -step)));
      }}
    >
      <box className="pill" spacing={4}>
        <label
          className="pill-icon"
          label={bind(speaker, "mute").as(m => m ? "󰸈" : "󰕾")}
        />
        <label
          className="pill-text"
          label={bind(speaker, "volume").as(v => `${Math.round(v * 100)}%`)}
        />
      </box>
    </eventbox>
  );
}
