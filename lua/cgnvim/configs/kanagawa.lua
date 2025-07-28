return {
  colors = {
    theme = {
      all = {
        ui = {
          bg_gutter = "none",
          float = {
            bg = "none",
          },
        },
      },
    },
  },
  overrides = function(_)
    return {
      NormalFloat = { bg = "none" },
      FloatBorder = { bg = "none" },
      FloatTitle = { bg = "none" },
    }
  end,
}
