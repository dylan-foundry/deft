Deft, a Dylan Environment For Tools
===================================

Deft is a framework for producing tools for building and working
with Dylan projects.  Projects can customize the behavior by
providing a ``deft-package.json`` file.

It is extensible and will support plug-in loading in the future.

It is currently under development.

Building Deft
-------------

You must build Deft with a build of Open Dylan from the master
branch. Deft relies on features which have been added to Open
Dylan in the 2014.1 release.

To get things set up correctly, please use the ``Makefile`` to
build Deft::

    make

Installing Deft
---------------

To install Deft, you can use the ``Makefile``::

    make install

This will copy a variety of things to ``/opt/deft`` and you
can then add ``/opt/deft/bin`` to your path.

If you want to change the install destination, you can override
the ``INSTALL_DIR``::

    make install INSTALL_DIR=/usr/local/deft

Getting Started
---------------

A few notes on getting started with Deft, until we have full
documentation...

cd into the directory containing the project you want to work on and
start Deft from there. It will look for config files and/or a
"registry" directory. In the simple case, where you only need that
single registry directory there is no need for a config file.  See the
Config Files section, below.

Command Line Interface
~~~~~~~~~~~~~~~~~~~~~~

Press Tab for command auto-completion. If you press Tab with no other
input Deft will show you a list of possible commands. Type "help<Tab>"
to see what you can get help on.

Press Control-d to exit.

Control-z (to suspend the process) is not yet implemented.

Config Files
~~~~~~~~~~~~

Deft looks in the current working directory for config files named
`deft-package.json` and `deft-package-local.json` and merges them
together, with the `-local` version overriding values from the
other. See the example file in the top-level deft directory for the
format.

Use the config file to configure a list of registries.  These are used
to instruct the compiler how to find and compile dylan libraries. See
the `Getting Started guide
<https://opendylan.org/documentation/getting-started-cli/source-registries.html>`
for more information on registries.

Use the "show registries" Deft command to make sure the list of
registries matches what you expect.
