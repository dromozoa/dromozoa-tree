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

local empty = require "dromozoa.commons.empty"
local queue = require "dromozoa.commons.queue"
local visit = require "dromozoa.commons.visit"

return function (tree, visitor, u)
  for u in tree:each_node() do
    visit(visitor, "initialize_node", u)
  end
  local q = queue():push(u)
  visit(visitor, "discover_node", u)
  while not empty(q) do
    u = q:pop()
    for v in u:each_child() do
      if visit(visitor, "examine_edge", u, v) ~= false then
        visit(visitor, "tree_edge", u, v)
        q:push(v)
        visit(visitor, "discover_node", v)
      end
    end
    visit(visitor, "finish_node", u)
  end
end
