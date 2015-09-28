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

function class:remove_node(uid)
  self.p[uid] = nil
  self.c[uid] = nil
  self.ns[uid] = nil
  self.ps[uid] = nil
end

function class:append_child(uid, vid)
  local p = self.p
  local c = self.c
  local ns = self.ns
  local ps = self.ps
  assert(p[vid] == 0)
  p[vid] = uid
  local next_id = c[uid]
  if next_id == 0 then
    c[uid] = vid
  else
    local prev_id = ps[next_id]
    ns[prev_id] = vid
    ns[vid] = next_id
    ps[vid] = prev_id
    ps[next_id] = vid
  end
end

function class:insert_child(uid, vid)
  local p = self.p
  local c = self.c
  local ns = self.ns
  local ps = self.ps
  assert(p[uid] ~= 0)
  assert(p[vid] == 0)
  p[vid] = p[uid]
  local next_id = uid
  local prev_id = ps[next_id]
  ns[prev_id] = vid
  ns[vid] = next_id
  ps[vid] = prev_id
  ps[next_id] = vid
end

function class:remove_child(uid, vid)
  local p = self.p
  local c = self.c
  local ns = self.ns
  local ps = self.ps
  assert(uid ~= 0)
  assert(p[vid] == uid)
  p[vid] = 0
  local next_id = ns[vid]
  if next_id == vid then
    assert(c[uid] == vid)
    c[uid] = 0
  else
    if c[uid] == vid then
      c[uid] = next_id
    end
    local prev_id = ps[vid]
    ns[prev_id] = next_id
    ps[next_id] = prev_id
  end
end

function class:each_child(uid)
  local c = self.c
  local start_id = c[uid]
  if start_id == 0 then
    return function () end
  else
    local ns = self.ns
    return coroutine.wrap(function ()
      local vid = start_id
      repeat
        coroutine.yield(vid)
        vid = ns[vid]
      until vid == start_id
    end)
  end
end

function class:parent(id)
  return self.p[id]
end

function class:child(id)
  return self.c[id]
end

function class:next_sibling(id)
  return self.ns[id]
end

function class:prev_sibling(uid)
  return self.ps[id]
end

local metatable = {
  __index = class;
}

return setmetatable(class, {
  __call = function ()
    return setmetatable(class.new(), metatable)
  end;
})
