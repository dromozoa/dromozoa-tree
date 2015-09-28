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

local model = require "dromozoa.tree.model"

local tree = model()

local root = tree:create_node()

local n1 = tree:create_node()
local n2 = tree:create_node()
local n3 = tree:create_node()
local n4 = tree:create_node()

tree:append_child(root, n1)
tree:append_child(root, n2)
tree:append_child(root, n3)
tree:append_child(root, n4)

tree:append_child(n1, tree:create_node())
tree:append_child(n1, tree:create_node())
tree:append_child(n2, tree:create_node())
tree:append_child(n2, tree:create_node())
tree:append_child(n3, tree:create_node())
tree:append_child(n3, tree:create_node())
tree:append_child(n4, tree:create_node())
tree:append_child(n4, tree:create_node())

tree:remove_child(root, n3)

for u in tree:each_child(root) do
  print(u)
end
