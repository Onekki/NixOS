const { query } = await Service.import("applications")

const WINDOW_NAME = "Launcher"

const DEFAULT_PROPS = {
  width: 500,
  height: 500,
  spacing: 4,
}

const AppView = props => {
  const { app, spacing } = props
  return Widget.Button({
    onClicked: () => {
      App.closeWindow(WINDOW_NAME)
      app.launch()
    },
    child: Widget.Box({
      spacing: spacing * 2,
      children: [
        Widget.Icon({
          icon: app.iconName ?? "",
          size: 42,
        }),
        Widget.Label({
          className: "title",
          label: app.name,
          xalign: 0,
          vpack: "center",
          truncate: "end",
        }),
      ],
    }),
  })
}

const LauncherView = props => {
  const { width, height, spacing } = props

  const keywordVAR = Variable("")
  const appListVAR = Utils.derive([keywordVAR],
    keyword => query(keyword))

  const searchView = Widget.Entry({
    hexpand: true,
    css: `margin: ${spacing}px;`,
    onAccept: () => {
      const [app] = appListVAR.value
      if (app) {
        app.launch()
      }
    },
    onChange: ({ text }) => {
      keywordVAR.value = text
    },
  })

  return Widget.Box({
    vertical: true,
    css: `margin: ${spacing}px;`,
    children: [
      searchView,
      Widget.Scrollable({
        hscroll: "never",
        css: `margin: ${spacing}px;`
          + `min-width: ${width}px;`
          + `min-height: ${height}px;`,
        child: Widget.Box({
          vertical: true,
          children: appListVAR.bind()
            .as(appList =>
              appList.map(app =>
                AppView({ app, spacing }))),
          spacing: spacing * 2,
        })
      }),
    ],
    setup: self => self.hook(App, (_, windowName, visible) => {
      if (windowName !== WINDOW_NAME) {
        return
      }

      if (visible) {
        searchView.grab_focus()
      }
    }),
  })
}


export const LAUNCHER = Widget.Window({
  name: WINDOW_NAME,
  setup: self => self.keybind("Escape", () => {
    App.closeWindow(WINDOW_NAME)
  }),
  visible: false,
  keymode: "exclusive",
  child: LauncherView(DEFAULT_PROPS),
})