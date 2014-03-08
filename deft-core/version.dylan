module: deft-core
synopsis:
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define constant $deft-release-name = "Deft";
define constant $deft-release-version = "0.1.0";

define cli-command show deft version ($deft-cli)
  implementation
    format-out("%s %s\n", $deft-release-name, $deft-release-version);
end;

define cli-command show dylan version ($deft-cli)
  implementation
    format-out("%s\n", release-full-name());
end;
