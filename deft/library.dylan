module: dylan-user
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define library deft
  use common-dylan;
  use command-line-parser;
  use io;

  use deft-core;
  use deft-server;
end library;

define module deft
  use common-dylan, exclude: { format-to-string };
  use command-line-parser;
  use format-out;

  use deft-core;
  use deft-server;
end module;
