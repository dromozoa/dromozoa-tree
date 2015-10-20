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

n3:insert_sibling(n4)
n1:insert_sibling(n5)
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

local t = tree()
local n1 = t:create_node()
local n2 = n1:tree():create_node():append_child(n1)
n1:append_child():append_child():append_child()
n1:insert_sibling():insert_sibling():insert_sibling()

local t = tree()
local n1 = t:create_node()
n1.foo = 17
n1.bar = 23
n1.baz = 37
n1.qux = 42

local m = 0
local n = 0
for k, v in n1:each_property() do
  m = m + v
  n = n + 1
end
assert(m == 17 + 23 + 37 + 42)
assert(n == 4)

local root = tree():create_node()
local n1 = root:append_child()
local n2 = root:append_child()
local n3 = root:append_child()
assert(root:count_children() == 3)
local children = root:children()
assert(#children == 3)
assert(children[1].id == n1.id)
assert(children[2].id == n2.id)
assert(children[3].id == n3.id)

assert(n1:is_first_child())
assert(not n2:is_first_child())
assert(not n3:is_first_child())
assert(not root:is_first_child())
assert(not root:is_last_child())
assert(not n1:is_last_child())
assert(not n2:is_last_child())
assert(n3:is_last_child())
