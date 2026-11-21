# Topiary formats this repo's OpenSCAD sources: `just fmt`, checked by `just check` and CI. Merged over
# topiary's built-in configuration, which carries the OpenSCAD grammar and its rules; only the indent
# changes, to the 4 spaces .editorconfig sets.
{
  languages = {
    openscad = {
      indent = "    ",
    },
  },
}
