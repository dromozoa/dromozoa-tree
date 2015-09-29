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

root:append_child(n1)
root:append_child(n2)
root:append_child(n3)
assert(root:count_children() == 3)

assert(n2:parent().id == root.id)
assert(n2:next_sibling().id == n3.id)
assert(n2:prev_sibling().id == n1.id)

n4:insert_before(n3)
n5:insert_before(n1)
local data = sequence()
for u in root:each_child() do
  data:push(u.id)
end
assert(equal(data, { n5.id, n1.id, n2.id, n4.id, n3.id }))

n2:remove()
local data = sequence()
for u in root:each_child() do
  data:push(u.id)
end
assert(equal(data, { n5.id, n1.id, n4.id, n3.id }))

n5:remove()
local data = sequence()
for u in root:each_child() do
  data:push(u.id)
end
assert(equal(data, { n1.id, n4.id, n3.id }))

n4:append_child(n5)

assert(n5:parent():parent().id == root.id)

n2:delete()

local m = 0
local n = 0
for u in t:each_node() do
  m = m + u.id
  n = n + 1
end
assert(m == root.id + n1.id + n3.id + n4.id + n5.id)
assert(n == 5)

root.level = 1
root.root = true
n1.level = 2
n3.level = 2
n4.level = 2
n5.level = 3

local n = 0
for u in t:each_node("root") do
  assert(u.id == root.id)
  assert(u.level == 1)
  n = n + 1
end
assert(n == 1)
