module: dylan-user
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define library deft
  use common-dylan;
  use io;

  use command-interface;
  use tty;

  use deft-core;

  use deft-browse;
  use deft-build;
  use deft-new;
  use deft-dfmc;
  use deft-server;
  use deft-test;
  use deft-deploy;
end library;

define module deft
  use common-dylan, exclude: { format-to-string };
  use format-out;

  use command-interface;
  use tty;

  use deft-core;

  use deft-browse;
  use deft-build;
  use deft-new;
  use deft-dfmc;
  use deft-server;
  use deft-test;
  use deft-deploy;
end module;
