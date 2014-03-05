module: dylan-user
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define library deft-core
  use common-dylan;
  use cli;
  use io;
  use json;
  use system;

  export deft-core;
end library;

define module deft-core
  use common-dylan, exclude: { format-to-string };
  use cli;
  use file-system;
  use format-out;
  use json;
  use locators;

  export $deft-cli;

  export deft-config;
end module;
