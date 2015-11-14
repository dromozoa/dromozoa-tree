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

local clone = require "dromozoa.commons.clone"
local sequence = require "dromozoa.commons.sequence"
local bfs = require "dromozoa.tree.bfs"
local dfs = require "dromozoa.tree.dfs"

local private_tree = function () end
local private_id = function () end

local function unpack_item(self)
  local tree = self[private_tree]
  return self[private_id], tree.model, tree.props, tree
end

local class = {}

function class.new(tree, id)
  return {
    [private_tree] = tree;
    [private_id] = id;
  }
end

function class:tree()
  local uid, model, props, tree = unpack_item(self)
  return tree
end

function class:delete(hierarchy)
  local uid, model, props, tree = unpack_item(self)
  if hierarchy then
    dfs(model, {
      finish_node = function (_, u)
        local uid = u.id
        model:remove_node(uid)
        model:delete_node(uid)
        props:remove_item(uid)
      end;
    }, self)
  end
  model:delete_node(uid)
  props:remove_item(uid)
end

function class:parent()
  local uid, model, props, tree = unpack_item(self)
  local vid = model:parent_node(uid)
  if vid ~= 0 then
    return tree:get_node(vid)
  end
end

function class:next_sibling()
  local uid, model, props, tree = unpack_item(self)
  return tree:get_node(model:next_sibling_node(uid))
end

function class:prev_sibling()
  local uid, model, props, tree = unpack_item(self)
  return tree:get_node(model:prev_sibling_node(uid))
end

function class:append_child(v)
  local uid, model, props, tree = unpack_item(self)
  if v == nil then
    v = tree:create_node()
  end
  model:append_child(uid, v.id)
  return v
end

function class:insert_sibling(v)
  local uid, model, props, tree = unpack_item(self)
  if v == nil then
    v = tree:create_node()
  end
  model:insert_sibling(uid, v.id)
  return v
end

function class:remove()
  local uid, model, props, tree = unpack_item(self)
  model:remove_node(uid)
  return self
end

function class:each_property()
  local uid, model, props, tree = unpack_item(self)
  return props:each_property(uid)
end

function class:each_child()
  local uid, model, props, tree = unpack_item(self)
  return coroutine.wrap(function ()
    for vid in model:each_child(uid) do
      coroutine.yield(tree:get_node(vid))
    end
  end)
end

function class:count_children()
  local uid, model, props, tree = unpack_item(self)
  return model:count_children(uid)
end

function class:children()
  local uid, model, props, tree = unpack_item(self)
  local children = sequence()
  for vid in model:each_child(uid) do
    children:push(tree:get_node(vid))
  end
  return children
end

function class:is_root()
  local uid, model, props, tree = unpack_item(self)
  return model:is_root(uid)
end

function class:is_leaf()
  local uid, model, props, tree = unpack_item(self)
  return model:is_leaf(uid)
end

function class:is_isolated()
  local uid, model, props, tree = unpack_item(self)
  return model:is_isolated(uid)
end

function class:is_first_child()
  local uid, model, props, tree = unpack_item(self)
  return model:is_first_child(uid)
end

function class:is_last_child()
  local uid, model, props, tree = unpack_item(self)
  return model:is_last_child(uid)
end

function class:bfs(visitor)
  local uid, model, props, tree = unpack_item(self)
  bfs(tree, visitor, self)
end

function class:dfs(visitor)
  local uid, model, props, tree = unpack_item(self)
  dfs(tree, visitor, self)
end

function class:duplicate()
  local uid, model, props, tree = unpack_item(self)
  local map = {}
  dfs(model, {
    discover_node = function (_, a)
      local b = tree:create_node()
      map[a.id] = b.id
      for k, v in a:each_property() do
        b[clone(k)] = clone(v)
      end
    end;
    finish_edge = function (_, a, b)
      model:append_child(map[a.id], map[b.id])
    end;
  }, self)
  return tree:get_node(map[uid]), map
end

function class:collapse()
  for u in self:each_child() do
    self:insert_sibling(u:remove())
  end
  return self:remove()
end

local metatable = {}

function metatable:__index(key)
  local uid, model, props, tree = unpack_item(self)
  if key == "id" then
    return uid
  else
    local value = props:get_property(uid, key)
    if value == nil then
      return class[key]
    end
    return value
  end
end

function metatable:__newindex(key, value)
  local uid, model, props, tree = unpack_item(self)
  if key == "id" then
    error "cannot modify constant"
  end
  props:set_property(uid, key, value)
end

return setmetatable(class, {
  __call = function (_, tree, id)
    return setmetatable(class.new(tree, id), metatable)
  end;
})
