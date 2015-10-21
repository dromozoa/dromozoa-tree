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

local function dfs(visitor, u)
  visit(visitor, "discover_node", u)
  for v in u:each_child() do
    if visit(visitor, "examine_edge", u, v) ~= false then
      visit(visitor, "tree_edge", u, v)
      dfs(visitor, v)
      visit(visitor, "finish_edge", u, v)
    end
  end
  visit(visitor, "finish_node", u)
end

return function (tree, visitor, s)
  for u in tree:each_node() do
    visit(visitor, "initialize_node", u)
  end
  if s == nil then
    for u in tree:each_node() do
      if u:parent() == nil then
        visit(visitor, "start_node", u)
        dfs(visitor, u)
      end
    end
  else
    visit(visitor, "start_node", s)
    dfs(visitor, s)
  end
end
