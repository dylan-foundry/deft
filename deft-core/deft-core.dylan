module: deft-core
synopsis:
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define command-root $deft-commands;

define class <deft-context> (<object>)
  slot dylan-current-project :: false-or(<project-object>) = #f;
end class;

define constant $deft-context = make(<deft-context>);
