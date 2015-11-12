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
local json = require "dromozoa.commons.json"
local sequence = require "dromozoa.commons.sequence"
local tree = require "dromozoa.tree"

local t = tree()
local n1 = t:create_node()
local n2 = t:create_node()
local n3 = t:create_node()

n1:append_child(n2)
n1:append_child(n3)

for u in n1:each_child() do
  u:insert_sibling()
end

local data = sequence()
for u in n1:each_child() do
  data:push(u.id)
end
assert(equal(data, { 4, 2, 5, 3 }))

for u in n1:each_child() do
  u:insert_sibling()
  u:remove():delete()
end

local data = sequence()
for u in n1:each_child() do
  data:push(u.id)
end
assert(equal(data, { 6, 7, 8, 9 }))

for u in n1:each_child() do
  u:remove()
end

local data = sequence()
for u in n1:each_child() do
  data:push(u.id)
end
assert(equal(data, {}))
