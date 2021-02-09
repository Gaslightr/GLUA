function load()
  -- Gaslua V1
  _G.GLUAVERSION = "Gaslua Alpha v1"

  --Switch Statements
  function _G.switch(var, table)
    if table[var] ~= nil then
      table[var]()
    elseif table["callback"] then
      table["callback"]()
      else
          error("Callback not found")
      end
  end

  -- Convert table to string
  function _G.table_tostring(table, indent)
    local ident = " "
    local ient=  ""
    if indent and type(indent) == "number" then
      for i = 1, indent do
        ident = ident.." "
        ient = ient.." "
      end
    end
    if type(table) == "table" then
      local o = "{\n"
      for i, t in next, table do
        if type(t) == "string" then
          o = o..indent..tostring(i).." = \""..t.."\",\n"
        elseif type(t) == "table" then
          o = o..ident..lu.table_tostring(t, indent + 1)..",\n"
        else
          o = o ..ident..tostring(i).." = "..tostring(t)..",\n"
        end
      end
      return o..ient.."}"
    end
  end

  -- Print a table
  function _G.print_table(table)
    if type(table) == "table" then
      local o = "Table = {\n"
      for i, t in next, table do
        if type(t) == "string" then
          o = o .."  "..tostring(i).." = \""..t.."\",\n"
        elseif type(t) == "table" then
          o = o.."  "..tostring(i).." = "..table_tostring(t, 2)..",\n"
        else
          o = o .."  "..tostring(i).." = "..tostring(t)..",\n"
        end
      end
      print(o.."}")
    end
  end

  local print_table = _G.print_table

  -- Create a class
  function _G.class(name, class, inherit)
    if type(name) == "string" and type(class) == "table" then
      local class_handler = {
        new = function(values)
          local obj = {}
          for i, t in next, class do
            obj[i] = t
          end
          if values ~= nil and type(values) == "table" then
            for i, t in next, values do
              obj[i] = t
            end
          end
          if inherit ~= nil and type(inherit) == "table"  and inherit.new then
            for i, t in next, inherit.new do
              obj[i] = t
            end
          end
          return obj
        end,
        name = name,
        default_properties = class
      }
      global(name, class_handler)
      return class_handler
    else
      error("Invalid class variable !")
    end
  end

  -- Clear the console
  _G.clear = function()
    for i = 1, 1000 do
      print("")
    end
  end

  -- Convert the string into a global variable
  _G.global = function(name, val)
    if type(name) == "string" then
      _G[name] = val
    end
  end

  _G.clonetable = function(table)
    if type(table) == "table" then
      local clone
      for i, t in next, table do 
        clone[i] = t
      end
      return clone
    end
    return nil
  end

  -- Add table to printing
  local old_print = print
  _G.print = function(text)
    if type(text) == "table" then
      print_table(text)
    else
      old_print(tostring(text))
    end
  end
end

return load 
