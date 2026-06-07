import { bind } from "astal";
import Wp from "gi://AstalWp";

export default function Mic() {
  const mic = Wp.get_default()?.audio.defaultMicrophone;
  if (!mic) return <box />;

  return (
    <eventbox
      onClick={() => { mic.mute = !mic.mute; }}
      onScroll={(_, e) => {
        const step = 0.02;
        mic.volume = Math.max(0, Math.min(1, mic.volume + (e.delta_y < 0 ? step : -step)));
      }}
    >
      <box
        className={bind(mic, "mute").as(m => m ? "pill mic-muted" : "pill")}
        spacing={4}
      >
        <label
          className="pill-icon"
          label={bind(mic, "mute").as(m => m ? "󰍭" : "󰍬")}
        />
      </box>
    </eventbox>
  );
}
