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

local tree = model()

local root = tree:create_node()

local n1 = tree:create_node()
local n2 = tree:create_node()
local n3 = tree:create_node()
local n4 = tree:create_node()
local n5 = tree:create_node()
local n6 = tree:create_node()

tree:append(root, n1)
tree:append(root, n2)
tree:append(root, n3)
tree:append(root, n4)
assert(tree:count(root) == 4)

tree:append(n1, tree:create_node())
tree:append(n1, tree:create_node())
assert(tree:count(n1) == 2)
tree:append(n2, tree:create_node())
tree:append(n2, tree:create_node())
assert(tree:count(n2) == 2)
tree:append(n3, tree:create_node())
tree:append(n3, tree:create_node())
assert(tree:count(n3) == 2)
tree:append(n4, tree:create_node())
tree:append(n4, tree:create_node())
assert(tree:count(n4) == 2)

tree:remove(n3)
assert(tree:count(root) == 3)

local data = sequence()
for v in tree:each(root) do
  sequence:push(v)
end
assert(equal(data, { n1, n2, n4 }))

assert(tree:parent_node(n2) == root)
assert(tree:next_sibling_node(n2) == n4)
assert(tree:prev_sibling_node(n2) == n1)

tree:insert(n2, n5)
local data = sequence()
for v in tree:each(root) do
  sequence:push(v)
end
assert(equal(data, { n1, n5, n2, n4 }))

tree:insert(n1, n6)
local data = sequence()
for v in tree:each(root) do
  sequence:push(v)
end
assert(equal(data, { n6, n1, n5, n2, n4 }))

tree:delete_node(n3)

local m = 0
local n = 0
for u in tree:each_node() do
  m = m + u
  n = n + 1
end
assert(m == 116)
assert(n == 14)

