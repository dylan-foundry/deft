module: deft-build
synopsis:
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define cli-command $deft-cli (show build registries)
  implementation
    begin
      let target-platform = target-platform-name();
      let registries = find-registries(as(<string>, target-platform-name()));
      for (registry in registries)
        format-out("  %s\n", registry.registry-location);
      end for;
    end;
end;
