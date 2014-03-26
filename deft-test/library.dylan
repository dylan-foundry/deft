module: dylan-user
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define library deft-test
  use common-dylan;
  use io;
  use system;

  use command-interface;

  use deft-core;
  use deft-build;

  use environment-protocols;

  export deft-test;
end library;

define module deft-test
  use common-dylan, exclude: { format-to-string };
  use format-out;
  use operating-system;

  use command-interface;

  use deft-core;
  use deft-build;

  use environment-protocols,
    import: { project-name, project-filename,
              project-executable-name,
              project-target-type,
              <project-object> };
end module;
