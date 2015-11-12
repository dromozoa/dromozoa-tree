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
assert(n1:count_children() == 3)

assert(n3:parent().id == n1.id)
assert(n3:next_sibling().id == n4.id)
assert(n3:prev_sibling().id == n2.id)

n4:insert_sibling(n5)
n2:insert_sibling(n6)
local data = sequence()
for u in n1:each_child() do
  data:push(u.id)
end
assert(equal(data, { n6.id, n2.id, n3.id, n5.id, n4.id }))

n3:remove()
local data = sequence()
for u in n1:each_child() do
  data:push(u.id)
end
assert(equal(data, { n6.id, n2.id, n5.id, n4.id }))

n6:remove()
local data = sequence()
for u in n1:each_child() do
  data:push(u.id)
end
assert(equal(data, { n2.id, n5.id, n4.id }))

n5:append_child(n6)

assert(n6:parent():parent().id == n1.id)

n3:delete()

local m = 0
local n = 0
for u in t:each_node() do
  m = m + u.id
  n = n + 1
end
assert(m == n1.id + n2.id + n4.id + n5.id + n6.id)
assert(n == 5)

n1.level = 1
n1.n1 = true
n2.level = 2
n4.level = 2
n5.level = 2
n6.level = 3

local n = 0
for u in t:each_node("n1") do
  assert(u.id == n1.id)
  assert(u.level == 1)
  n = n + 1
end
assert(n == 1)

local t = tree()
local n2 = t:create_node()
local n3 = n2:tree():create_node():append_child(n2)
n2:append_child():append_child():append_child()
n2:insert_sibling():insert_sibling():insert_sibling()

local t = tree()
local n2 = t:create_node()
n2.foo = 17
n2.bar = 23
n2.baz = 37
n2.qux = 42

local m = 0
local n = 0
for k, v in n2:each_property() do
  m = m + v
  n = n + 1
end
assert(m == 17 + 23 + 37 + 42)
assert(n == 4)

local n1 = tree():create_node()
local n2 = n1:append_child()
local n3 = n1:append_child()
local n4 = n1:append_child()
assert(n1:count_children() == 3)
local children = n1:children()
assert(#children == 3)
assert(children[1].id == n2.id)
assert(children[2].id == n3.id)
assert(children[3].id == n4.id)

assert(n1:is_root())
assert(not n2:is_root())
assert(not n3:is_root())
assert(not n4:is_root())

assert(not n1:is_leaf())
assert(n2:is_leaf())
assert(n3:is_leaf())
assert(n4:is_leaf())

assert(not n1:is_first_child())
assert(n2:is_first_child())
assert(not n3:is_first_child())
assert(not n4:is_first_child())

assert(not n1:is_last_child())
assert(not n2:is_last_child())
assert(not n3:is_last_child())
assert(n4:is_last_child())
