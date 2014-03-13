module: dylan-user
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define library deft-dfmc
  use common-dylan;
  use command-system;
  use io;

  use deft-core;

  use dfmc-flow-graph;

  export deft-dfmc;
end library;

define module deft-dfmc
  use common-dylan, exclude: { format-to-string };
  use command-system;
  use format-out;

  use dfmc-flow-graph;

  use deft-core;
end module;
