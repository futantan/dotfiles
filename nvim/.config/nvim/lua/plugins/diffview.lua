local function enforce_tree_file_panel(view)
  if not view.panel then
    return
  end

  view.panel.listing_style = "tree"
  view.panel.tree_options.flatten_dirs = false
  view.panel.tree_options.folder_statuses = "always"
  view.panel:update_components()
  view.panel:render()
  view.panel:redraw()
end

return {
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewFileHistory",
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
    },
    opts = {
      file_panel = {
        listing_style = "tree",
        tree_options = {
          flatten_dirs = false,
          folder_statuses = "always",
        },
      },
      hooks = {
        view_opened = enforce_tree_file_panel,
        view_enter = enforce_tree_file_panel,
      },
    },
  },
}
