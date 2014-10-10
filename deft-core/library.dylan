module: dylan-user
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define library deft-core
  use common-dylan;
  use command-interface;
  use io;
  use json;
  use strings;
  use system;
  use release-info;

  use build-system;
  use dfmc-environment-projects;
  use environment-protocols;
  use projects;
  use user-projects;
  use registry-projects;

  export deft-core;
end library;

define module deft-core
  use common-dylan, exclude: { format-to-string };
  use command-interface;
  use file-system;
  use format-out;
  use format,
    import: { format,
              format-to-string };
  use json;
  use locators;
  use release-info;
  use standard-io;
  use streams;
  use strings;

  use build-system, import: { target-platform-name };
  use environment-protocols,
    exclude: { application-filename, application-arguments, parameter-name };
  use registry-projects, import: { find-registries, registry-location };

  export $deft-commands;

  export <dylan-project-parameter>,
         <open-dylan-project-parameter>,
         $deft-context,
         <deft-context>;

  export $deft-release-name,
         $deft-release-version;

  export deft-config;

  export dylan-project,
         deft-open-project,
         deft-close-project,
         dylan-current-project;
  
  export <template>,
         write-templates;
end module;
