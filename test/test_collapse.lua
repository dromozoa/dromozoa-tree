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

n1:append_child(n2)
n1:append_child(n3)
n1:append_child(n4)
n3:append_child(n5)
n3:append_child(n6)

n3.color = true
n3:collapse()
assert(n3.color == true)
n3:delete()
assert(n3.color == nil)

local data = sequence()
for u in n1:each_child() do
  data:push(u.id)
end
assert(equal(data, { n2.id, n5.id, n6.id, n4.id }))

t:write_graphviz(assert(io.open("test.dot", "w"))):close()
