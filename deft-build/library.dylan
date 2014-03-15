module: dylan-user
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define library deft-build
  use common-dylan;
  use io;
  use system;
  use strings;

  use command-interface;

  use deft-core;

  use build-system;
  use environment-protocols;
  use environment-reports;
  use dfmc-back-end-implementations;

  export deft-build;
end library;

define module deft-build
  use common-dylan, exclude: { format-to-string };
  use streams;
  use format,
    import: { format };
  use format-out;
  use standard-io;
  use file-system;
  use locators;
  use strings;

  use command-interface;

  use deft-core;

  use build-system, import: { default-build-script };
  use environment-protocols,
    exclude: { application-filename, application-arguments, parameter-name };
  use environment-reports;

  export deft-build-project,
         deft-clean-project;
end module;
