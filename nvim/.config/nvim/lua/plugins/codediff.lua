return {
  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
    opts = {
      diff = {
        layout = "side-by-side",
        max_computation_time_ms = 1000,
      },
      explorer = {
        auto_open_on_cursor = true,
      },
    },
  },
}
