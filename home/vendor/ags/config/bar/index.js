
const Left = () => {
  return Widget.Box({
    spacing: 8,
    children: []
  })
}

const Bar = (monitor) => {
  return Widget.Window({
    name: "bar",
    className: "bar",
    monitor: monitor,
    anchor: ["top"],
    exclusivity: "exclusive",
      child: Widget.CenterBox({
        start_widget: Left(),
        center_widget: Center(),
        end_widget: Right(),
      }),
  })
}