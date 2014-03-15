module: dylan-user
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define library deft-dfmc
  use common-dylan;
  use command-interface;
  use io;
  use serialization;

  use deft-core;

  use dfmc-debug-back-end;
  use dfmc-definitions;
  use dfmc-flow-graph;

  export deft-dfmc;
end library;

define module deft-dfmc
  use common-dylan, exclude: { format-to-string };
  use command-interface;
  use format-out;
  use json-serialization;
  use print;
  use standard-io;
  use streams;

  use deft-core;

  use dfmc-debug-back-end;
  use dfmc-definitions, import: { <signature-spec> };
  use dfmc-flow-graph;
end module;
