package = "typedlua"
version = "0.1-1"
source = {
    url = "git://github.com/mildred/typedlua.git"
}
description = {
    summary = "An Optional Type System for Lua",
    detailed = [[
      Typed Lua is a typed superset of Lua that compiles to plain Lua.
      It provides optional type annotations, compile-time type checking, and
      class-based object oriented programming through the definition of classes,
      interfaces, and modules.
    ]],
    homepage = "https://github.com/andremm/typedlua",
    license = "private"
}
dependencies = {
    "lua ~> 5.2",
    "lpeg >= 0.12"
}
build = {
    type = "builtin",
    modules = {
      ["typedlua.checker"]   = "typedlua/checker.lua";
      ["typedlua.lsl"]       = "typedlua/lsl.lua";
      ["typedlua.parser"]    = "typedlua/parser.lua";
      ["typedlua.pp"]        = "typedlua/pp.lua";
      ["typedlua.scope"]     = "typedlua/scope.lua";
      ["typedlua.tlast"]     = "typedlua/tlast.lua";
      ["typedlua.tlchecker"] = "typedlua/tlchecker.lua";
      ["typedlua.tlcode"]    = "typedlua/tlcode.lua";
      ["typedlua.tldparser"] = "typedlua/tldparser.lua";
      ["typedlua.tllexer"]   = "typedlua/tllexer.lua";
      ["typedlua.tlparser"]  = "typedlua/tlparser.lua";
      ["typedlua.tlst"]      = "typedlua/tlst.lua";
      ["typedlua.tltype"]    = "typedlua/tltype.lua";
      ["typedlua.types"]     = "typedlua/types.lua";
    },
    install = {
      bin = {"tlc"}
    }
}

