import { bind } from "astal";
import { weather } from "../../lib/data";

function icon(code: string) {
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

export default function Weather() {
  return (
    <box
      className="pill"
      spacing={4}
      tooltipText={bind(weather).as(w =>
        `${w.desc} | Feels like ${w.feels_like}°C | Humidity: ${w.humidity}%`,
      )}
    >
      <label className="pill-icon" label={bind(weather).as(w => icon(w.code))} />
      <label className="pill-text" label={bind(weather).as(w => `${w.temp_c}°`)} />
    </box>
  );
}
