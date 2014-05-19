module: dylan-user
author: Francesco Ceccon
copyright: See LICENSE file in this distribution.

define library deft-browse
  use common-dylan;
  use command-interface;
  use collections;
  use io;
  use registry-projects;
  use system;

  use deft-core;
  use deft-dfmc;

  use environment-protocols;

  export deft-browse;
end library;

define module deft-browse
  use common-dylan, exclude: { format-to-string };
  use command-interface;
  use file-system;
  use format-out;
  use locators;
  use operating-system,
    exclude: { load-library,
               run-application  };
  use registry-projects;
  use table-extensions;

  use deft-core;
  use deft-dfmc;

  use environment-protocols,
    exclude: { application-filename,
               application-arguments,
               parameter-name };
end module;
