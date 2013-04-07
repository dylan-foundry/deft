module: dylan-user
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define library deft-core
  use common-dylan;
  use io;
end library;

define module deft-core
  use common-dylan, exclude: { format-to-string };
  use format-out;
end module;
