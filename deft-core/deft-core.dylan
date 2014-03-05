module: deft-core
synopsis:
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define variable *config* :: false-or(<string-table>)= #f;

define cli-root $deft-cli;

define function parse-config-file
    (filename :: <string>)
 => (config :: false-or(<string-table>))
  let config-file = as(<file-locator>, filename);
  if (file-exists?(config-file))
    with-open-file (stream = config-file, direction: #"input")
      block ()
        parse-json(stream)
      exception (ex :: <json-error>)
        format-err("WARNING: Parsing config file '%s' failed:\n%s\n---\n",
                   filename, ex);
        #f
      end
    end
  end
end function;

define function merge-config
    (config1 :: false-or(<string-table>),
     config2 :: false-or(<string-table>))
 => (merged-config :: false-or(<string-table>))
  case
    config1 & config2 =>
      let merged-config = make(<string-table>);
      for (value keyed-by key in config1)
        merged-config[key] := value;
      end for;
      for (value keyed-by key in config2)
        merged-config[key] := value;
      end for;
      merged-config;
    config1 => config1;
    config2 => config2;
    otherwise => #f
  end case
end function;

define function load-deft-config () => ()
  let project-config = parse-config-file(".deft");
  let local-config = parse-config-file(".deft_local");
  *config* := merge-config(project-config, local-config);
  if (~ *config*)
    format-err("WARNING: No config files found for project.\n");
  end if;
end function;

define function deft-config () => (config :: false-or(<string-table>))
  if (~ *config*)
    load-deft-config();
  end if;
  *config*
end function;
