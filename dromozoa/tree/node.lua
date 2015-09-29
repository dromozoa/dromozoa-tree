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

function class:delete()
  local uid, model, props, tree = unpack_item(self)
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

function class:next_sibiling()
  local uid, model, props, tree = unpack_item(self)
  return tree:get_node(model:next_sibiling_node(uid))
end

function class:prev_sibling()
  local uid, model, props, tree = unpack_item(self)
  return tree:get_node(model:prev_sibiling_node(uid))
end

function class:append_child(v)
  local uid, model, props, tree = unpack_item(self)
  model:append_child(uid, v.id)
end

function class:insert_before(v)
  local uid, model, props, tree = unpack_item(self)
  model:insert_before(uid, v.id)
end

function class:remove()
  local uid, model, props, tree = unpack_item(self)
  model:remove_node(uid)
end

function class:each_child()
  local uid, model, props, tree = unpack_item(self)
  return model:each_child(uid)
end

function class:count_children()
  local uid, model, props, tree = unpack_item(self)
  return model:count_children(uid)
end

local metatable = {
  __index = class;
}

return setmetatable(class, {
  __call = function (_, tree, id)
    return setmetatable(class.new(tree, id), metatable)
  end;
})
