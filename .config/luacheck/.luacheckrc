-- vim:ft=lua:
stds.nvim = {
    globals = {
        "vim",
        "unpack",
        "nvim",
        "p",
        string = {fields = {basename = {}}},
        table = {fields = {print = {}}},
    },
    read_globals = {string = {fields = {basename = {}}}},
}
std = "min+nvim"
-- allow_defined = true
-- ignore = {"131"}
