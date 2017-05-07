-- Copyright (C) 2015 Tomoyuki Fujimori <moyu@dromozoa.com>
--
-- This file is part of dromozoa-tree.
--
-- dromozoa-tree is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- dromozoa-tree is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with dromozoa-tree.  If not, see <http://www.gnu.org/licenses/>.

local pairs = require "dromozoa.commons.pairs"
local visit = require "dromozoa.commons.visit"

local function write_attributes(out, attributes, prolog, epilog)
  if attributes ~= nil then
    if prolog ~= nil then
      out:write(prolog)
    end
    out:write(" [")
    local first = true
    for k, v in pairs(attributes) do
      if first then
        first = false
      else
        out:write(", ")
      end
      out:write(k, " = ", v)
    end
    out:write("]")
    if epilog ~= nil then
      out:write(epilog)
    end
  end
end

local function write(out, tree, visitor)
  out:write("digraph g {\n")
  if visitor == nil then
    tree:dfs({
      discover_node = function (_, u)
        if u:is_isolated() then
          out:write(u.id, ";\n")
        end
      end;
      examine_edge = function (_, u, v)
        out:write(u.id, " -> ", v.id, ";\n")
      end;
    })
  else
    write_attributes(out, visit(visitor, "graph_attributes"), "graph", ";\n")
    write_attributes(out, visit(visitor, "default_node_attributes"), "node", ";\n")
    write_attributes(out, visit(visitor, "default_edge_attributes"), "edge", ";\n")
    tree:dfs({
      discover_node = function (_, u)
        local attributes = visit(visitor, "node_attributes", u)
        if attributes ~= nil or u:is_isolated() then
          out:write(u.id)
          write_attributes(out, attributes)
          out:write(";\n")
        end
      end;
      examine_edge = function (_, u, v)
        out:write(u.id, " -> ", v.id)
        write_attributes(out, visit(visitor, "edge_attributes", u, v), "edge", ";\n")
        out:write(";\n")
      end;
    })
  end
  out:write("}\n")
  return out
end

return {
  write = write;
}
