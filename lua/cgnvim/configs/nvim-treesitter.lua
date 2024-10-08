return {
  ensure_installed = {
    ---------------------------------------------------------------------------
    ---------------------------------- LANGUAGES ------------------------------
    ---------------------------------------------------------------------------

    "c",
    "cpp",
    "glsl",
    "hlsl",
    "lua",
    "bash",
    --  "javascript",
    --  "typescript",
    --  "html",
    --  "css",
    --  "python",
    --  "powershell",
    --  "c_sharp",

    ---------------------------------------------------------------------------
    -------------------------------- BUILD SYSTEMS ----------------------------
    ---------------------------------------------------------------------------

    "cmake",
    "ninja",

    ---------------------------------------------------------------------------
    -------------------------------- DOCUMENTATION ----------------------------
    ---------------------------------------------------------------------------

    "doxygen",
    "markdown",

    ---------------------------------------------------------------------------
    -------------------------------- SERIALIZATION ----------------------------
    ---------------------------------------------------------------------------

    "proto",
    "json",
    "yaml",
    "xml",

    ---------------------------------------------------------------------------
    ------------------------------------ MISC ---------------------------------
    ---------------------------------------------------------------------------

    "objdump",
    "gitignore",

  },
  sync_install = false,
  highlight = { enable = true },
  indent = { enable = true },
}
