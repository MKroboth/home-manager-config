import { Binding } from "astal";

type Props = {
  icon: string | Binding<string>;
  label: string;
  sublabel: string | Binding<string>;
  active: boolean | Binding<boolean>;
  onClick: () => void;
};

export default function CCToggle({ icon, label, sublabel, active, onClick }: Props) {
  return (
    <eventbox onClick={onClick}>
      <box
        className={(active as Binding<boolean>)?.as
          ? (active as Binding<boolean>).as(a => `cc-toggle ${a ? "cc-toggle-active" : ""}`)
          : `cc-toggle ${active ? "cc-toggle-active" : ""}`}
        vertical
        spacing={2}
      >
        <label className="cc-toggle-icon" label={icon} />
        <label className="cc-toggle-label" label={label} />
        <label className="cc-toggle-sublabel" maxWidthChars={14} truncate label={sublabel} />
      </box>
    </eventbox>
  );
}
