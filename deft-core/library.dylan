module: dylan-user
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define library deft-core
  use common-dylan;
  use cli;
  use io;

  export deft-core;
end library;

define module deft-core
  use common-dylan, exclude: { format-to-string };
  use cli;
  use format-out;

  export $deft-cli;
end module;
