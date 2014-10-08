module: dylan-user
author: Fabrice Leal
copyright: See LICENSE file in this distribution.

define library deft-deploy
  use common-dylan;
  use command-interface;
  use io;

  use environment-protocols;

  use deft-core;

  export deft-deploy;
end library;

define module deft-deploy
  use common-dylan;
  use command-interface;

  use environment-protocols,
    exclude: { application-filename, application-arguments, parameter-name };

  use format-out;
  
  use deft-core;
end module;


