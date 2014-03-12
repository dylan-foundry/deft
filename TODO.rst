TODO List
=========

Config
------

* Showing config should look nicer than just dumping JSON.
* Should be able to modify configuration and have it reload.
* Should be able to set configuration parameters and save the updated
  ``deft-package.json`` back to disk.

  * This requires the JSON extensions for preserving file order
    and pretty printing.

JSON Extensions
---------------

* JSON should load into an ordered table / plist so that the order from the
  file is maintained.
* JSON should support pretty printing.

System Extensions
-----------------

* Should be able to watch for changes to files and invoke the provided
  callback. (Use libuv?)

CLI Extensions
--------------

* Mandatory parameters are not implemented yet.
* Should CLI integrate with libuv?
* Need to set an exit status from something like ``test`` when run from
  the shell and not interactively.
* Need to handle conditions correctly and not abort the process.

Registry Management
-------------------

* Can not currently alter registry entries at runtime. (They are
  calculated once and stored in the ``project-dynamic-enviroment``.
* Add ability to add a registry entry.
* Do we really need personal vs system registries? We currently
  never use system registries, do we?
* Can we make the registry that we add based on current working
  directory be relative rather than absolute?
* Finish ``populate-registries`` function.

Projects
--------

* How do we get at project data, like ``Target-Type`` and
  ``Executable``? (We'd like to use this when running tests.)

Schema Validation
-----------------

* Should finish up the Dylan Foundry ``schema-core`` code and
  use it to validate the ``deft-package.json`` instead of
  hand-rolled code within functions like ``populate-registries``.

Build
-----

* How should we pull in the system-provided Jam files and
  runtime libraries rather than having our own copy?
* Default to less output.
* Node completion on ``<dylan-project-parameter>`` should be against
  registries rather than open projects.

New
---

* Borrow the code from ``make-dylan-app``.
* Parameterize more:

  * new project
  * new application
  * new library
  * new tests

* Make it support adding to an existing project when it is inside
  an existing project.
* Make it set up basic deft integration for new project or tests.

  * This will require the ability to modify and save out configuration.
