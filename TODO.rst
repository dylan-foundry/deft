TODO List
=========

Config
------

* Showing config should look nicer than just dumping JSON.
* Should be able to modify configuration and have it reload.
* Should be able to set configuration parameters and save the updated
  ``deft-package.json`` back to disk.

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

Registry Management
-------------------

* Can not currently alter registry entries at runtime. (They are
  calculated once and stored in the ``project-dynamic-enviroment``.
* Add ability to add a registry entry.
* Do we really need personal vs system registries? We currently
  never use system registries, do we?
* Can we make the registry that we add based on current working
  directory be relative rather than absolute?
* Finish ``populate-registry`` function.
