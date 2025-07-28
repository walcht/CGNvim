local options = {
  options = {
    mode = "buffers",
    numbers = "ordinal",
    close_command = "Bdelete! %d",
    right_mouse_command = "Bdelete! %d",
    left_mouse_command = "buffer %d",
    middle_mouse_command = nil,
    indicator = {
      icon = "▎",
      style = "icon",
    },
    modified_icon = "*",
    close_icon = "",
    left_trunc_marker = "",
    right_trunc_marker = "",
    max_name_length = 18,
    max_prefix_length = 16,
    truncate_names = true,
    diagnostics = "nvim_lsp",
    diagnostics_update_in_insert = false,
    offsets = {
      {
        filetype = "NvimTree",
        text = "Explorer",
        text_align = "center",
        separator = true,
      },
    },
    show_buffer_close_icons = true,
    show_close_icon = true,
    show_tab_indicators = false,
    show_duplicate_prefix = true,
    persist_buffer_sort = true,
    separator_style = "thin",
    always_show_bufferline = true,
    sort_by = "id",
  },
}

return options
