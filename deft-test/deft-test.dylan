module: deft-test
synopsis:
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define variable *tests* = make(<stretchy-vector>);

define function ensure-tests-loaded () => ()
  populate-tests();
end;

define function populate-tests () => ()
  let config = deft-config();
  let tests = element(config, "tests", default: #f);
  if (tests & instance?(tests, <sequence>))
    for (test-entry in tests)
      if (instance?(test-entry, <string>))
        add!(*tests*, test-entry);
      else
        format-err("ERROR: test entries should be strings. Found %=\n", test-entry);
      end if;
    end for;
  elseif (tests)
    format-err("ERROR: 'tests' should be a sequence of strings.\n");
  end if;
end;

define cli-command show tests ($deft-cli)
  implementation
    begin
      ensure-tests-loaded();
      format-out("Tests:\n");
      if (empty?(*tests*))
        format-out("  *** None ***\n");
      else
        for (test-entry in *tests*)
          format-out("  %s\n", test-entry);
        end;
      end if;
    end;
end;
