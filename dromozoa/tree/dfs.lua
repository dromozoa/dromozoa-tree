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

local visit = require "dromozoa.commons.visit"

local function dfs(tree, visitor, u)
  visit(visitor, "discover_node", tree, u)
  for v in u:each_child() do
    dfs(tree, visitor, v)
  end
  visit(visitor, "finish_node", tree, u)
end

return function (tree, visitor, s)
  if s == nil then
    for u in tree:each_node() do
      if u:parent() == nil then
        dfs(tree, visitor, u)
      end
    end
  else
    dfs(tree, visitor, s)
  end
end
