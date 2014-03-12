module: deft-core
synopsis:
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define method dylan-project-named (context :: <deft-context>, string :: <string>)
 => (project :: false-or(<project-object>));
  any?(method (project)
        => (project :: false-or(<project-object>));
         (project-name(project) = as-lowercase(string)) & project;
       end,
       open-projects());
end method;

define method dylan-project (context :: <deft-context>, parameter :: false-or(<string>))
 => (project :: false-or(<project-object>));
  if (parameter)
    dylan-project-named(context, parameter);
  else
    dylan-current-project(context);
  end;
end method;



define class <open-dylan-project-parameter> (<command-parameter>)
end class;

define method node-complete (param :: <open-dylan-project-parameter>, parser :: <command-parser>, token :: false-or(<command-token>))
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

define class <dylan-project-parameter> (<command-parameter>)
end class;

define method node-complete (param :: <dylan-project-parameter>, parser :: <command-parser>, token :: false-or(<command-token>))
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

define method note-load-warning
    (context :: <deft-context>, project :: <project-object>,
     warning :: <warning-object>)
 => ();
  let stream = *standard-output*;
  new-line(stream);
  print-environment-object-name(stream, project, warning, full-message?: #t);
  new-line(stream)
end method note-load-warning;


define function deft-open-project (project :: <string>) => (project)
  let (pobj, invalid?) = open-project-from-locator(as(<file-locator>, project));
  case
    pobj =>
      open-project-compiler-database
        (pobj, warning-callback: curry(note-load-warning, $deft-context, pobj));

      pobj.project-opened-by-user? := #t;

      dylan-current-project($deft-context) := pobj;

      pobj;
    invalid? =>
      error("Cannot open '%s' as it is not a project", project);
    otherwise =>
      error("Unable to open project '%s'", project);
  end
end;

define function deft-close-project (project :: <string>)
  let p = dylan-project($deft-context, project);
  close-project(p);
end;

define command show project ($deft-commands)
  simple parameter project :: <string>,
    node-class: <open-dylan-project-parameter>;
  implementation
    begin
      let specified? = project | #f;
      let p = dylan-project($deft-context, project);
      if (p)
        format-out("%s: %s\n",
                   if (specified?) "Project" else "Current project" end if,
                   project-name(p));
        format-out("  class: %s\n", object-class(p));
        format-out("  target-type: %s\n", project-target-type(p));
        format-out("\n");
      end;
      format-out("Open projects:\n");
      let ops = open-projects();
      if (empty?(ops))
        format-out("  *** None ***\n");
      else
        for (p in open-projects())
          format-out("  %s (%s)\n", project-name(p), project-filename(p));
        end for;
      end if;
    end;
end;

define command open ($deft-commands)
  simple parameter project :: <string>,
    node-class: <dylan-project-parameter>;
  implementation
    begin
      format-out("Opening %s!\n", project);
      let p = deft-open-project(project);
      format-out("Opened project %s (%s)",
                 p.project-name,
                 p.project-filename);

    end;
end;

define command close ($deft-commands)
  simple parameter project :: <string>,
    node-class: <open-dylan-project-parameter>;
  implementation
    begin
      format-out("Closing %s!\n", project);
      deft-close-project(project);
    end;
end;
