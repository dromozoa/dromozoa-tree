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
local model = require "dromozoa.tree.model"

local t = model()

local root = t:create_node()
local n1 = t:create_node()
local n2 = t:create_node()
local n3 = t:create_node()
local n4 = t:create_node()
local n5 = t:create_node()
local n6 = t:create_node()

t:append_child(root, n1)
t:append_child(root, n2)
t:append_child(root, n3)
t:append_child(root, n4)
assert(t:count_children(root) == 4)

t:append_child(n1, t:create_node())
t:append_child(n1, t:create_node())
assert(t:count_children(n1) == 2)
t:append_child(n2, t:create_node())
t:append_child(n2, t:create_node())
assert(t:count_children(n2) == 2)
t:append_child(n3, t:create_node())
t:append_child(n3, t:create_node())
assert(t:count_children(n3) == 2)
t:append_child(n4, t:create_node())
t:append_child(n4, t:create_node())
assert(t:count_children(n4) == 2)

t:remove_node(n3)
assert(t:count_children(root) == 3)

local data = sequence()
for v in t:each_child(root) do
  data:push(v)
end
assert(equal(data, { n1, n2, n4 }))

assert(t:parent_node(n2) == root)
assert(t:next_sibling_node(n2) == n4)
assert(t:prev_sibling_node(n2) == n1)

t:insert_sibling(n2, n5)
local data = sequence()
for v in t:each_child(root) do
  data:push(v)
end
assert(equal(data, { n1, n5, n2, n4 }))

t:insert_sibling(n1, n6)
local data = sequence()
for v in t:each_child(root) do
  data:push(v)
end
assert(equal(data, { n6, n1, n5, n2, n4 }))

t:delete_node(n3)

local m = 0
local n = 0
for u in t:each_node() do
  m = m + u
  n = n + 1
end
assert(m == 116)
assert(n == 14)
