return [=========[--[[
Lua Standard Libraries Typed Lua description file
]]

arg : {string}

-- Basic Functions

assert : (any, string?) -> (any, string?) | (nil)
collectgarbage : (string?, number?) -> (number) | (number, number) | (boolean)
dofile : (string?) -> (any*)
error : (string, number?) -> ()
_G : { string:any }
getmetatable : (any) -> (any?)
ipairs : ({any}) -> ((any*) -> (any*))
load : (string|(any*) -> (any*), string?, string?, any?) -> ((any*) -> (any*))?
loadfile : (string?, string?, any?) -> ((any*) -> (any*))?
next : ({any:any}, any?) -> (any, any) | (nil)
pairs : ({any}) -> ((any*) -> (any*))
pcall : ((any*) -> (any*), any*) -> (true, any*) | (false, string)
print : (value*) -> ()
rawequal : (value, value) -> (boolean)
rawget : ({}, any) -> (any)
rawlen : ({}|string) -> (number)
rawset : ({any:any}, any, any) -> ({any:any})
select : (number, any*) -> (any*)
setmetatable : ({any:any}, {any:any}|nil) -> ({any:any}) -- it is a primitive in Typed Lua
tonumber : (value, number|string?) -> (number) | (nil)
tostring : (value) -> (string)
type : (value) -> ("nil"|"number"|"string"|"boolean"|"table"|"function"|"thread"|"userdata") -- it is a primitive in Typed Lua
_VERSION : string
xpcall : ((any*) -> (any*), any, any*) -> (true, any*) | (false, string)

-- Coroutine Manipulation

coroutine : {
  "create" : ((any*) -> (any*)) -> (any),
  "resume" : (any, any*) -> (true, any*) | (false, string),
  "running" : () -> (any, boolean),
  "status" : (any) -> ("running"|"suspended"|"normal"|"dead"),
  "wrap" : ((any*) -> (true, any*) | (false, string)) -> ((any*) -> (true, any*) | (false, string)),
  "yield" : (any*) -> ()
}

-- Modules

require : (string) -> (any) -- is a primitive in Typed Lua

package : {
  "config" : string,
  "cpath" : string,
  "loaded" : {string:{any:any}},
  "loadlib" : (string, string) -> (true)?,
  "path" : string,
  "preload" : {string:{any:any}},
  "searchers" : {(any*) -> (any*)},
  "searchpath" : (string, string, string?, string?) -> (string)?
}

-- String Manipulation

string : {
  "byte" : (string, number?, number?) -> (number*),
  "char" : (number*) -> (string),
  "dump" : ((value*) -> (value*)) -> (string),
  "find" : (string, string, number?, true?) -> (number, number) | (nil),
  "format" : (string, any*) -> (string),
  "gmatch" : (string, string) -> ((any*) -> (any*)),
  "gsub" : (string, string, string|{}|(any*) -> (any*), number?) -> (string, number),
  "len" : (string) -> (number),
  "lower" : (string) -> (string),
  "match" : (string, string, number?) -> (string, string*) | (nil),
  "rep" : (string, number, string?) -> (string),
  "reverse" : (string) -> (string),
  "sub" : (string, number, number?) -> (string),
  "upper" : (string) -> (string)
}

-- Table Manipulation

table : {
  "concat" : ({string|number}, string?, number?, number?) -> (string),
  "insert" : ({any}, any) -> (),
  "pack" : (any*) -> ({number:any, "n":number}),
  "remove" : ({any}, number?) -> (any),
  "sort" : ({any}, nil|(any, any) -> (boolean)) -> (),
  "unpack" : ({any}, number?, number?) -> (any*)
}

-- Mathematical Functions

math : {
  "abs" : (number) -> (number),
  "acos" : (number) -> (number),
  "asin" : (number) -> (number),
  "atan" : (number) -> (number),
  "atan2" : (number, number) -> (number),
  "ceil" : (number) -> (number),
  "cos" : (number) -> (number),
  "cosh" : (number) -> (number),
  "deg" : (number) -> (number),
  "exp" : (number) -> (number),
  "floor" : (number) -> (number),
  "fmod" : (number, number) -> (number),
  "frexp" : (number) -> (number, number),
  "huge" : number,
  "ldexp" : (number, number) -> (number),
  "log" : (number, number?) -> (number),
  "max" : (number, number*) -> (number),
  "min" : (number, number*) -> (number),
  "modf" : (number) -> (number, number),
  "pi" : number,
  "pow" : (number, number) -> (number),
  "rad" : (number) -> (number),
  "random" : (number?, number?) -> (number),
  "randomseed" : (number) -> (),
  "sin" : (number) -> (number),
  "sinh" : (number) -> (number),
  "sqrt" : (number) -> (number),
  "tan" : (number) -> (number),
  "tanh" : (number) -> (number)
}

-- Bitwise Operations

bit32 : {
  "arshift" : (number, number) -> (number),
  "band" : (number*) -> (number),
  "bnot" : (number) -> (number),
  "bor" : (number*) -> (number),
  "btest" : (number*) -> (number),
  "bxor" : (number*) -> (number),
  "extract" : (number, number, number?) -> (number),
  "replace" : (number, number, number, number?) -> (number),
  "lrotate" : (number, number) -> (number),
  "lshift" : (number, number) -> (number),
  "rrotate" : (number, number) -> (number),
  "rshift" : (number, number) -> (number)
}

-- Input and Output Facilities

io : {
  "close" : (any?) -> (boolean) | (nil, string) | (true?, string, number),
  "flush" : () -> (boolean),
  "input" : (string|any|nil) -> (any),
  "lines" : (string|any|nil) -> ((any*) -> (any*)),
  "open" : (string, "r"|"w"|"a"|"r+"|"w+"|"a+"|"rb"|"wb"|"ab"|"r+b"|"w+b"|"w+b"|nil) -> (any) | (nil, string, number),
  "output" : (string|any|nil) -> (any),
  "popen" : (string, "r"|"w"|nil) -> (any) | (nil, string, number),
  "read" : ("*n"|"*a"|"*l"|"*L"|number*) -> (string|number*),
  "tmpfile" : () -> (any),
  "type" : (value) -> ("file"|"closed file"|nil),
  "write" : (string|number*) -> (any) | (nil, string, number)
}

-- Operating System Facilities

os : {
  "clock" : () -> (number),
  "date" : (string?, number?) -> (string) | ({"year":number, "month":number, "day":number,
                                              "hour":number, "min":number, "sec":number,
                                              "wday":number, "yday":number, "isdst":boolean}),
  "difftime" : (number, number?) -> (number),
  "execute" : (string?) -> (boolean) | (true?, string, number),
  "exit" : (boolean|number?, value?) -> (),
  "getenv" : (string) -> (string?),
  "remove" : (string) -> (true) | (nil, string, number),
  "rename" : (string, string) -> (true) | (nil, string, number),
  "setlocale" : (string?, "all"|"collate"|"ctype"|"monetary"|"numeric"|"time"|nil) -> (string) | (nil),
  "time" : ({"year":number, "month":number, "day":number,
             "hour":number?, "min":number?, "sec":number?,
             "wday":number?, "yday":number?, "isdst":boolean?}?) -> (number),
  "tmpname" : () -> (string)
}

-- The Debug Library

debug : {
  "debug" : () -> (),
  "gethook" : (any*) -> (any*),
  "getinfo" : (any*) -> (any*),
  "getlocal" : (any*) -> (any*),
  "getmetatable" : (value) -> (any),
  "getregistry" : () -> (any),
  "getupvalue" : (any, any) -> (any*),
  "getuservalue" : (value) -> (any),
  "sethook" : (any*) -> (),
  "setlocal" : (any*) -> (string?),
  "setmetatable" : (any, any) -> (any),
  "setupvalue" : (any, any, any) -> (string?),
  "setuservalue" : (any, any) -> (any),
  "traceback" : (any*) -> (any*),
  "upvalueid" : (any, any) -> (any),
  "upvaluejoin" : (value, value, value, value) -> ()
}
]=========]