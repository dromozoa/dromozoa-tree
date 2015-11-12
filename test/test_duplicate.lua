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

local tree = require "dromozoa.tree"

local t = tree()
local n1 = t:create_node()
local n2 = t:create_node()
local n3 = t:create_node()
local n4 = t:create_node()

n3.color = 1
n4.color = 2

n1:append_child(n2)
n2:append_child(n3)
n2:append_child(n4)

local n5, map = n2:duplicate()

n1:append_child(n5)

local children = n5:children()
assert(#children == 2)
local n6 = children[1]
local n7 = children[2]
assert(map[n3.id] == n6.id)
assert(map[n4.id] == n7.id)
assert(n6.color == 1)
assert(n7.color == 2)
