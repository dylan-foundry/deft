module: dylan-user
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define library deft-new
  use common-dylan;
  use command-interface;
  use io;

  use deft-core;

  export deft-new;
end library;

define module deft-new
  use common-dylan, exclude: { format-to-string };
  use command-interface;
  use format-out;

  use deft-core;
end module;
