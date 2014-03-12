module: deft-core
synopsis:
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define function populate-registries () => ()
  let config = deft-config();
  let registries = element(config, "registries", default: #f);
  if (registries & instance?(registries, <sequence>))
    for (registry-entry in registries)
      if (instance?(registry-entry, <string>))
        // Do something ...
      else
        format-err("ERROR: registry entries should be strings. Found %=\n", registry-entry);
      end if;
    end for;
  elseif (registries)
    format-err("ERROR: 'registries' should be a sequence of strings.\n");
  end if;
end;

define command show registries ($deft-commands)
  implementation
    begin
      let target-platform = target-platform-name();
      let registries = find-registries(as(<string>, target-platform-name()));
      for (registry in registries)
        format-out("  %s\n", registry.registry-location);
      end for;
    end;
end;

populate-registries();
