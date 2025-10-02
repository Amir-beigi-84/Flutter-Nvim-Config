return {
  "L3MON4D3/LuaSnip",
  event = "VeryLazy",
  config = function()
    local ls = require("luasnip")
    local s, t, i = ls.snippet, ls.text_node, ls.insert_node

    -- Dart snippets
    ls.add_snippets("dart", {
      s("stl", {
        t({ "class " }),
        i(1, "MyWidget"),
        t({ " extends StatelessWidget {", "  const " }),
        i(2, "MyWidget"),
        t({
          "({super.key});",
          "",
          "  @override",
          "  Widget build(BuildContext context) {",
          "    return ",
        }),
        i(0, "const Placeholder()"),
        t({ ";", "  }", "}" }),
      }),
      s("stf", {
        t({ "class " }),
        i(1, "MyWidget"),
        t({ " extends StatefulWidget {", "  const " }),
        i(2, "MyWidget"),
        t({ "({super.key});", "", "  @override", "  State<" }),
        i(3, "MyWidget"),
        t({ "> createState() => _" }),
        i(4, "MyWidget"),
        t({ "State();", "}", "", "class _" }),
        i(4, "MyWidget"),
        t({ "State extends State<" }),
        i(3, "MyWidget"),
        t({
          ">{",
          "  @override",
          "  Widget build(BuildContext context) {",
          "    return ",
        }),
        i(0, "const Placeholder()"),
        t({ ";", "  }", "}" }),
      }),
    })
  end,
}
