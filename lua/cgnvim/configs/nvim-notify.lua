vim.api.nvim_create_autocmd('User', {
  pattern = 'LazyLoad',
  callback = function(event)
    if event.data == "nvim-notify" then
      vim.notify = require("notify")
    end
  end
})


return {
  background_colour = "NotifyBackground",
  fps = 15,
  icons = {
    DEBUG = "",
    ERROR = "",
    INFO = "",
    TRACE = "✎",
    WARN = ""
  },
  level = 2,
  minimum_width = 60,
  -- max_width = 80,
  render = "default",
  stages = "static",
  time_formats = {
    notification = "%T",
    notification_history = "%FT%T"
  },
  timeout = 7500,
  top_down = true
}
