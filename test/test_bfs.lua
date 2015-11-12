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

local equal = require "dromozoa.commons.equal"
local sequence = require "dromozoa.commons.sequence"
local tree = require "dromozoa.tree"

local t = tree()
local n1 = t:create_node()
local n2 = t:create_node()
local n3 = t:create_node()
local n4 = t:create_node()
local n5 = t:create_node()
local n6 = t:create_node()
local n7 = t:create_node()

n1:append_child(n2)
n1:append_child(n3)
n2:append_child(n4)
n2:append_child(n5)
n3:append_child(n6)
n3:append_child(n7)

local data = sequence()
n1:bfs({
  discover_node = function (_, u)
    data:push("discover", u.id)
  end;
  finish_node = function (_, u)
    data:push("finish", u.id)
  end;
})

assert(equal(data, {
  "discover", n1.id,
    "discover", n2.id,
    "discover", n3.id,
  "finish", n1.id,
      "discover", n4.id,
      "discover", n5.id,
    "finish", n2.id,
      "discover", n6.id,
      "discover", n7.id,
    "finish", n3.id,
      "finish", n4.id,
      "finish", n5.id,
      "finish", n6.id,
      "finish", n7.id,
}))

local data = sequence()
n1:bfs({
  discover_node = function (_, u)
    data:push("discover", u.id, 0)
  end;
  examine_edge = function (_, u, v)
    data:push("examine", u.id, v.id)
    if u.id == n1.id and v.id == n3.id then
      return false
    end
  end;
  finish_node = function (_, u)
    data:push("finish", u.id, 0)
  end;
})

assert(equal(data, {
  "discover", n1.id, 0,
    "examine", n1.id, n2.id,
    "discover", n2.id, 0,
    "examine", n1.id, n3.id,
  "finish", n1.id, 0,
      "examine", n2.id, n4.id,
      "discover", n4.id, 0,
      "examine", n2.id, n5.id,
      "discover", n5.id, 0,
    "finish", n2.id, 0,
      "finish", n4.id, 0,
      "finish", n5.id, 0,
}))
