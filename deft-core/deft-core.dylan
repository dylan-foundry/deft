module: deft-core
synopsis:
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define variable *config* = #f;

define cli-root $deft-cli;

define function load-deft-config () => ()
  let config-file = as(<file-locator>, ".deft");
  if (file-exists?(config-file))
    with-open-file (stream = config-file, direction: #"input")
      block ()
        *config* := parse-json(stream);
      exception (ex :: <json-error>)
        format-err("WARNING: Parsing config file failed:\n%s\n---\n", ex)
      end;
    end;
  else
    format-err("WARNING: No config file present.\n")
  end;
end function;

define function deft-config () => (config)
  if (~ *config*)
    load-deft-config();
  end if;
  *config*
end function;
