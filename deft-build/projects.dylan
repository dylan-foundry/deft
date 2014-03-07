module: deft-build
synopsis:
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define class <dylan-cli> (<object>)
  slot dylan-current-project :: false-or(<project-object>) = #f;
end class;


define method dylan-project-named (cli :: <dylan-cli>, string :: <string>)
 => (project :: false-or(<project-object>));
  any?(method (project)
        => (project :: false-or(<project-object>));
         (project-name(project) = as-lowercase(string)) & project;
       end,
       open-projects());
end method;

define method dylan-project (cli :: <dylan-cli>, parameter :: false-or(<string>))
 => (project :: false-or(<project-object>));
  if (parameter)
    dylan-project-named(cli, parameter);
  else
    dylan-current-project(cli);
  end;
end method;



define class <cli-open-dylan-project> (<cli-parameter>)
end class;

define method node-complete (param :: <cli-open-dylan-project>, parser :: <cli-parser>, token :: false-or(<cli-token>))
 => (completions :: <list>);
  let names = map(project-name, open-projects());
  let compls =
    if (token)
      let string = as-lowercase(token-string(token));
      let compls = choose(rcurry(starts-with?, string), names);
      compls;
    else
      names;
    end;
  as(<list>, compls);
end method;

define class <cli-dylan-project> (<cli-parameter>)
end class;

define method node-complete (param :: <cli-dylan-project>, parser :: <cli-parser>, token :: false-or(<cli-token>))
 => (completions :: <list>);
  let names = map(project-name, open-projects());
  let compls =
    if (token)
      let string = as-lowercase(token-string(token));
      let compls = choose(rcurry(starts-with?, string), names);
      unless (member?(string, compls, test: \=)
                | member?(longest-common-prefix(names), compls, test: \=))
        compls := add!(compls, string);
      end;
      compls;
    else
      names;
    end;
  as(<list>, compls);
end method;


define function find-project-for-library
    (library-name :: <symbol>) => (project :: false-or(<project-object>))
  find-project(as(<string>, library-name))
end function find-project-for-library;

define function open-project-from-locator (locator :: <file-locator>)
 => (project :: false-or(<project-object>), invalid? :: <boolean>)
  let pathname = merge-locators(expand-pathname(locator), working-directory());
  let extension = locator-extension(pathname);
  select (extension by \=)
    lid-file-extension() =>
      values(import-project-from-file(pathname), #f);
    project-file-extension() =>
      values(open-project(pathname), #f);
    executable-file-extension() =>
      values(create-exe-project-from-file(pathname), #f);
    otherwise =>
      if (~extension)
        let library-name = as(<symbol>, locator.locator-base);
        values(find-project-for-library(library-name), #f)
      else
        values(#f, #t);
      end;
  end;
end function;

define constant $cli = make(<dylan-cli>);

define cli-command $deft-cli (show project)
  simple parameter project :: <string>,
    node-class: <cli-dylan-project>;
  implementation
    begin
      let p = dylan-project($cli, project);
      if (p)
        format-out("Project %s\n\n", project-name(p));
        format-out("  class %s\n", object-class(p));
        format-out("  directory %s\n", project-directory(p));
      end;
      for (p in open-projects())
        format-out("Open %s\n", project-name(p));
      end;
    end;
end;

define cli-command $deft-cli (open)
  simple parameter project :: <string>,
    node-class: <cli-dylan-project>;
  implementation
    begin
      format-out("Opening %s!\n", project);
      let (pobj, invalid?) = open-project-from-locator(as(<file-locator>, project));
      case
        pobj =>
          open-project-compiler-database
            (pobj, warning-callback: curry(note-compiler-warning, $cli, pobj));

          format-out("Opened project %s (%s)",
                     pobj.project-name,
                     pobj.project-filename);

          pobj.project-opened-by-user? := #t;

          dylan-current-project($cli) := pobj;

          pobj;
        invalid? =>
          error("Cannot open '%s' as it is not a project", project);
        otherwise =>
          error("Unable to open project '%s'", project);
      end
    end;
end;

define cli-command $deft-cli (close)
  simple parameter project :: <string>,
    node-class: <cli-dylan-project>;
  implementation
    begin
      format-out("Closing %s!\n", project);
      let p = dylan-project($cli, project);
      close-project(p);
    end;
end;
