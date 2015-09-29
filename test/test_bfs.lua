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

local root = t:create_node()
local n1 = t:create_node()
local n2 = t:create_node()
local n3 = t:create_node()
local n4 = t:create_node()
local n5 = t:create_node()
local n6 = t:create_node()

root:append_child(n1)
root:append_child(n2)
n1:append_child(n3)
n1:append_child(n4)
n2:append_child(n5)
n2:append_child(n6)

local data = sequence()
root:bfs({
  discover_node = function (ctx, tree, node)
    data:push("discover", node.id)
  end;
  finish_node = function (ctx, tree, node)
    data:push("finish", node.id)
  end;
})
assert(equal(data, {
  "discover", root.id,
    "discover", n1.id,
    "discover", n2.id,
  "finish", root.id,
      "discover", n3.id,
      "discover", n4.id,
    "finish", n1.id,
      "discover", n5.id,
      "discover", n6.id,
    "finish", n2.id,
      "finish", n3.id,
      "finish", n4.id,
      "finish", n5.id,
      "finish", n6.id,
}))
