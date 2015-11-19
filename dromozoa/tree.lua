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

local property_map = require "dromozoa.commons.property_map"
local push = require "dromozoa.commons.push"
local dfs = require "dromozoa.tree.dfs"
local graphviz = require "dromozoa.tree.graphviz"
local model = require "dromozoa.tree.model"
local node = require "dromozoa.tree.node"

local function each(self, constructor, iterator, context)
  return coroutine.wrap(function ()
    for id in iterator, context do
      coroutine.yield(constructor(self, id))
    end
  end)
end

local function id(item)
  if type(item) == "table" then
    return item.id
  else
    return item
  end
end

local class = {}

function class.new()
  return {
    model = model();
    props = property_map();
  }
end

function class:empty()
  return self.model:empty()
end

function class:create_node(...)
  local u = node(self, self.model:create_node())
  push(u, 0, ...)
  return u
end

function class:get_node(u)
  return node(self, id(u))
end

function class:each_node(key)
  if key == nil then
    return each(self, class.get_node, self.model:each_node())
  else
    return each(self, class.get_node, self.props:each_item(key))
  end
end

function class:count_node(key)
  if key == nil then
    return self.model:count_node()
  else
    return self.props:count_item(key)
  end
end

function class:clear_node_properties(key)
  self.props:clear(key)
end

function class:dfs(visitor)
  dfs(self, visitor, nil)
end

function class:write_graphviz(out, visitor)
  return graphviz.write(out, self, visitor)
end

local metatable = {
  __index = class;
}

return setmetatable(class, {
  __call = function ()
    return setmetatable(class.new(), metatable)
  end;
})
