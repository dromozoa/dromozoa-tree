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

local empty = require "dromozoa.commons.empty"
local pairs = require "dromozoa.commons.pairs"

local class = {}

function class.new()
  return {
    n = 0;
    p = {};
    c = {};
    ns = {};
    ps = {};
  }
end

function class:create_node()
  local uid = self.n + 1
  self.n = uid
  self.p[uid] = 0
  self.c[uid] = 0
  self.ns[uid] = uid
  self.ps[uid] = uid
  return uid
end

function class:delete_node(uid)
  self.p[uid] = nil
  self.c[uid] = nil
  self.ns[uid] = nil
  self.ps[uid] = nil
end

function class:empty()
  return empty(self.p)
end

function class:each_node()
  return pairs(self.p)
end

function class:count_node()
  local count = 0
  for _ in pairs(self.p) do
    count = count + 1
  end
  return count
end

function class:parent_node(uid)
  return self.p[uid]
end

function class:next_sibling_node(uid)
  return self.ns[uid]
end

function class:prev_sibling_node(uid)
  return self.ps[uid]
end

function class:append_child(uid, vid)
  local p = self.p
  local c = self.c
  p[vid] = uid
  local next_id = c[uid]
  if next_id == 0 then
    c[uid] = vid
  else
    local ns = self.ns
    local ps = self.ps
    local prev_id = ps[next_id]
    ns[prev_id] = vid
    ns[vid] = next_id
    ps[vid] = prev_id
    ps[next_id] = vid
  end
end

function class:insert_sibling(next_id, vid)
  local p = self.p
  local c = self.c
  local ns = self.ns
  local ps = self.ps
  local uid = p[next_id]
  p[vid] = uid
  if c[uid] == next_id then
    c[uid] = vid
  end
  local prev_id = ps[next_id]
  ns[prev_id] = vid
  ns[vid] = next_id
  ps[vid] = prev_id
  ps[next_id] = vid
end

function class:remove_node(vid)
  local p = self.p
  local c = self.c
  local ns = self.ns
  local uid = p[vid]
  p[vid] = 0
  local next_id = ns[vid]
  if next_id == vid then
    c[uid] = 0
  else
    local ps = self.ps
    if c[uid] == vid then
      c[uid] = next_id
    end
    local prev_id = ps[vid]
    ns[prev_id] = next_id
    ps[next_id] = prev_id
  end
end

function class:each_child(uid)
  local vid = self.c[uid]
  if vid == 0 then
    return function () end
  else
    local ns = self.ns
    local last_id = self.ps[vid]
    return coroutine.wrap(function ()
      while true do
        local next_id = ns[vid]
        coroutine.yield(vid)
        if vid == last_id then
          break
        end
        vid = next_id
      end
    end)
  end
end

function class:count_children(uid)
  local vid = self.c[uid]
  if vid == 0 then
    return 0
  else
    local ns = self.ns
    local count = 0
    local start_id = vid
    repeat
      count = count + 1
      vid = ns[vid]
    until vid == start_id
    return count
  end
end

function class:is_root(uid)
  return self.p[uid] == 0
end

function class:is_leaf(uid)
  return self.c[uid] == 0
end

function class:is_isolated(uid)
  return self.p[uid] == 0 and self.c[uid] == 0
end

function class:is_first_child(uid)
  return self.c[self.p[uid]] == uid
end

function class:is_last_child(uid)
  return self.ps[self.c[self.p[uid]]] == uid
end

local metatable = {
  __index = class;
}

return setmetatable(class, {
  __call = function ()
    return setmetatable(class.new(), metatable)
  end;
})
