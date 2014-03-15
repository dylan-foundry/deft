module: dylan-user
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define library deft-server
  use common-dylan;
  use io;

  use http-server;

  use deft-core;

  export deft-server;
end library;

define module deft-server
  use common-dylan, exclude: { format-to-string };
  use format-out;

  use http-server;

  use deft-core;

  export deft-server-ensure-started,
         deft-server-ensure-stopped,
         deft-server-add-resource;
end module;
