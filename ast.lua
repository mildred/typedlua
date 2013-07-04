--[[
This file documents Typed Lua AST and implements some useful functions.

Abstract Syntax Tree

type ID = String

type IsVarArg = Bool

type FieldList = ([Exp],[(Exp,Exp)])

type ParList = ([ID],IsVarArg)

type FuncBody = (ParList,Stm)

data FuncName = Function [ID] | Method [ID]

data Var = VarID ID | VarIndex Exp Exp

data Stm = StmBlock [Stm]
         | StmIfElse Exp Stm Stm
         | StmWhile Exp Stm
         | StmForNum ID Exp Exp Exp Stm
         | StmForGen [ID] [Exp] Stm
         | StmRepeat Stm Exp
         | StmFunction FuncName FuncBody
         | StmLocalFunction ID FuncBody
         | StmLabel ID
         | StmGoTo ID
         | StmBreak
         | StmAssign [Var] [Exp]
         | StmLocalVar [ID] [Exp]
         | StmRet [Exp]
         | StmCall Exp

data Exp = ExpNil
         | ExpFalse
         | ExpTrue
         | ExpDots
         | ExpNum Double
         | ExpStr String
         | ExpVar Var
         | ExpFunction FuncBody
         | ExpTableConstructor FieldList
         | ExpMethodCall Exp ID [Exp]
         | ExpFunctionCall Exp [Exp]
         | ExpAdd Exp Exp
         | ExpSub Exp Exp
         | ExpMul Exp Exp
         | ExpDiv Exp Exp
         | ExpMod Exp Exp
         | ExpPow Exp Exp
         | ExpConcat Exp Exp
         | ExpNE Exp Exp
         | ExpEQ Exp Exp
         | ExpLT Exp Exp
         | ExpLE Exp Exp
         | ExpGT Exp Exp
         | ExpGE Exp Exp
         | ExpAnd Exp Exp
         | ExpOr Exp Exp
         | ExpNot Exp
         | ExpMinus Exp
         | ExpLen Exp

Functions

tostring :: AST -> String

print :: AST -> Void
]]

local ast = {}

local block2str, stm2str, exp2str, var2str
local explist2str, varlist2str, fieldlist2str, namelist2str

local function iscntrl (x)
  if (x >= 0 and x <= 31) or (x == 127) then return true end
  return false
end

local function isprint (x)
  return not iscntrl(x)
end

local function fixed_string (str)
  local new_str = ""
  for i=1,string.len(str) do
    char = string.byte(str, i)
    if char == 34 then new_str = new_str .. string.format("\\\"")
    elseif char == 92 then new_str = new_str .. string.format("\\\\")
    elseif char == 7 then new_str = new_str .. string.format("\\a")
    elseif char == 8 then new_str = new_str .. string.format("\\b")
    elseif char == 12 then new_str = new_str .. string.format("\\f")
    elseif char == 10 then new_str = new_str .. string.format("\\n")
    elseif char == 13 then new_str = new_str .. string.format("\\r")
    elseif char == 9 then new_str = new_str .. string.format("\\t")
    elseif char == 11 then new_str = new_str .. string.format("\\v")
    else
      if isprint(char) then
        new_str = new_str .. string.format("%c", char)
      else
        new_str = new_str .. string.format("\\%03d", char)
      end
    end
  end
  return new_str
end

namelist2str = function (namelist)
  local l = {}
  for k,v in ipairs(namelist) do
    l[k] = string.format('"%s"', v)
  end
  return "[" .. table.concat(l, ",") .. "]"
end

fieldlist2str = function (fieldlist)
  local l = {{},{}}
  for k,v in ipairs(fieldlist[1]) do
    l[1][k] = exp2str(v[1])
  end
  for k,v in ipairs(fieldlist[2]) do
    l[2][k] = "(" .. exp2str(v[1]) .. "," .. exp2str(v[2]) .. ")"
  end
  return " ([" .. table.concat(l[1], ",") .. "],[" .. table.concat(l[2], ",") .. "])"
end

varlist2str = function (varlist)
  local l = {}
  for k,v in ipairs(varlist) do
    l[k] = var2str(v)
  end
  return " [" .. table.concat(l, ",") .. "]"
end

explist2str = function (explist)
  local l = {}
  for k,v in ipairs(explist) do
    l[k] = exp2str(v)
  end
  return " [" .. table.concat(l, ",") .. "]"
end

var2str = function (var)
  local tag = var.tag
  local str = tag
  if tag == "VarID" then -- VarID ID
    str = str .. " \"" .. var[1] .. "\""
  elseif tag == "VarIndex" then -- VarIndex Exp Exp
    str = str .. " (" .. exp2str(var[1]) .. ")"
    str = str .. " (" .. exp2str(var[2]) .. ")"
  else
    error("expecting a variable, but got a " .. tag)
  end
  return str
end

exp2str = function (exp)
  local tag = exp.tag
  local str = tag
  if tag == "ExpNil" or
     tag == "ExpFalse" or
     tag == "ExpTrue" or
     tag == "ExpDots" then
  elseif tag == "ExpNum" then -- ExpNum Double
    str = str .. string.format(" %.1f", exp[1])
  elseif tag == "ExpStr" then -- ExpStr String
    str = str .. string.format(" \"%s\"", fixed_string(exp[1]))
  elseif tag == "ExpVar" then -- ExpVar Var
    str = str .. " (" .. var2str(exp[1]) .. ")"
  elseif tag == "ExpFunction" then -- ExpFunction ParList Stm
    local is_vararg = "False"
    if exp[1].is_vararg then is_vararg = "True" end
    str = str .. " ((" .. namelist2str(exp[1]) .. "," .. is_vararg .. "),"
    str = str .. stm2str(exp[2]) .. ")"
  elseif tag == "ExpTableConstructor" then -- ExpTableConstructor FieldList
    str = str .. fieldlist2str(exp[1])
  elseif tag == "ExpMethodCall" then -- ExpMethodCall Exp ID [Exp]
    str = str .. " (" .. exp2str(exp[1]) .. ")"
    str = str .. " \"" .. exp[2] .. "\""
    str = str .. explist2str(exp[3])
  elseif tag == "ExpFunctionCall" then -- ExpFunctionCall Exp [Exp]
    str = str .. " (" .. exp2str(exp[1]) .. ")"
    str = str .. explist2str(exp[2])
  elseif tag == "ExpAdd" or -- ExpAdd Exp Exp 
         tag == "ExpSub" or -- ExpSub Exp Exp
         tag == "ExpMul" or -- ExpMul Exp Exp
         tag == "ExpDiv" or -- ExpDiv Exp Exp
         tag == "ExpMod" or -- ExpMod Exp Exp
         tag == "ExpPow" or -- ExpPow Exp Exp
         tag == "ExpConcat" or -- ExpConcat Exp Exp
         tag == "ExpNE" or -- ExpNE Exp Exp
         tag == "ExpEQ" or -- ExpEQ Exp Exp
         tag == "ExpLT" or -- ExpLT Exp Exp
         tag == "ExpLE" or -- ExpLE Exp Exp
         tag == "ExpGT" or -- ExpGT Exp Exp
         tag == "ExpGE" or -- ExpGE Exp Exp
         tag == "ExpAnd" or -- ExpGE Exp Exp
         tag == "ExpOr" then -- ExpOr Exp Exp
    str = str .. " (" .. exp2str(exp[1]) .. ")"
    str = str .. " (" .. exp2str(exp[2]) .. ")"
  elseif tag == "ExpNot" or -- ExpNot Exp
         tag == "ExpMinus" or -- ExpMinus Exp
         tag == "ExpLen" then -- ExpLen Exp
    str = str .. " (" .. exp2str(exp[1]) .. ")"
  else
    error("expecting an expression, but got a " .. tag)
  end
  return str
end

stm2str = function (stm)
  local tag = stm.tag
  local str = tag
  if tag == "StmBlock" then -- StmBlock [Stm]
    str = block2str(stm)
  elseif tag == "StmIfElse" then -- StmIfElse Exp Stm Stm
    str = str .. " (" .. exp2str(stm[1]) .. ")"
    str = str .. " (" .. stm2str(stm[2]) .. ")"
    str = str .. " (" .. stm2str(stm[3]) .. ")"
  elseif tag == "StmWhile" then -- StmWhile Exp Stm
    str = str .. " (" .. exp2str(stm[1]) .. ")"
    str = str .. " (" .. stm2str(stm[2]) .. ")"
  elseif tag == "StmForNum" then -- StmForNum ID Exp Exp Exp Stm
    str = str .. " \"" .. stm[1] .. "\""
    str = str .. " (" .. exp2str(stm[2]) .. ")"
    str = str .. " (" .. exp2str(stm[3]) .. ")"
    str = str .. " (" .. exp2str(stm[4]) .. ")"
    str = str .. " (" .. stm2str(stm[5]) .. ")"
  elseif tag == "StmForGen" then -- StmForGen [ID] [Exp] Stm
    str = str .. " "
    str = str .. namelist2str(stm[1])
    str = str .. explist2str(stm[2])
    str = str .. " (" .. stm2str(stm[3]) .. ")"
  elseif tag == "StmRepeat" then -- StmRepeat Stm Exp
    str = str .. " (" .. stm2str(stm[1]) .. ")"
    str = str .. " (" .. exp2str(stm[2]) .. ")"
  elseif tag == "StmFunction" then -- StmFunction FuncName ParList Stm
    local is_vararg = "False"
    if stm[2].is_vararg then is_vararg = "True" end
    str = str .. " (" .. stm[1].tag .. " " .. namelist2str(stm[1]) .. ")"
    str = str .. " ((" .. namelist2str(stm[2]) .. "," .. is_vararg .. "),"
    str = str .. stm2str(stm[3]) .. ")"
  elseif tag == "StmLocalFunction" then -- StmLocalFunction ID ParList Stm
    local is_vararg = "False"
    if stm[2].is_vararg then is_vararg = "True" end
    str = str .. " \"" .. stm[1] .. "\""
    str = str .. " ((" .. namelist2str(stm[2]) .. "," .. is_vararg .. "),"
    str = str .. stm2str(stm[3]) .. ")"
  elseif tag == "StmLabel" or -- StmLabel ID
         tag == "StmGoTo" then -- StmGoTo ID
    str = str .. " \"" .. stm[1] .. "\""
  elseif tag == "StmBreak" then -- StmBreak
  elseif tag == "StmAssign" then -- StmAssign [Var] [Exp]
    str = str .. varlist2str(stm[1])
    str = str .. explist2str(stm[2])
  elseif tag == "StmLocalVar" then -- StmLocalVar [ID] [Exp]
    str = str .. " "
    str = str .. namelist2str(stm[1])
    str = str .. explist2str(stm[2])
  elseif tag == "StmRet" then -- StmRet [Exp]
    str = str .. explist2str(stm[1])
  elseif tag == "StmCall" then -- StmCall Exp
    str = str .. " (" .. exp2str(stm[1]) .. ")"
  else
    error("expecting a statement, but got a " .. tag)
  end
  return str
end

block2str = function (block)
  local tag = block.tag
  if tag ~= "StmBlock" then
    error("expecting a block, but got a " .. tag)
  end
  local l = {}
  for k,v in ipairs(block) do
    l[k] = stm2str(v)
  end
  return tag .. " [" .. table.concat(l, ",") .. "]"
end

function ast.tostring (t)
  assert(type(t) == "table")
  return block2str(t)
end

function ast.print (t)
  assert(type(t) == "table")
  print(ast.tostring(t))
end

function ast.dump (t, i)
  if i == nil then i = 0 end
  io.write(string.format("{\n"))
  io.write(string.format("%s[tag] = %s\n", string.rep(" ", i+2), t.tag))
  io.write(string.format("%s[pos] = %s\n", string.rep(" ", i+2), t.pos))
  for k,v in ipairs(t) do
    io.write(string.format("%s[%s] = ", string.rep(" ", i+2), tostring(k)))
    if type(v) == "table" then
      ast.dump(v,i+2)
    else
      io.write(string.format("%s\n", tostring(v)))
    end
  end
  io.write(string.format("%s}\n", string.rep(" ", i)))
end

return ast
