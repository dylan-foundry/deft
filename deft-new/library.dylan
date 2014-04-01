module: dylan-user
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define library deft-new
  use common-dylan;
  use command-interface;
  use io;
  use strings;
  use system;

  use deft-core;

  export deft-new;
end library;

define module deft-new
  use common-dylan, exclude: { format-to-string };
  use command-interface;
  use format-out;
  use format,
    import: { format,
              format-to-string };
  use file-system,
    import: { create-directory,
              file-exists?,
              with-open-file,
              working-directory };
  use locators,
    import: { <directory-locator>,
              <file-locator>,
              merge-locators,
              subdirectory-locator };
  use strings,
    import: { alphabetic?,
              alphanumeric?,
              decimal-digit? };

  use deft-core;
end module;
