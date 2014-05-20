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
Dylan after the 2013.2 release.

To get things set up correctly, please use the ``Makefile`` to
build Deft::

    make

Installing Deft
---------------

To install Deft, you can use the ``Makefile``::

    make install

This will copy a variety of things to ``/opt/deft`` and you
can then add ``/opt/deft/bin`` to your path.
