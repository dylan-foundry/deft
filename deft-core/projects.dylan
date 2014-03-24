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
 => (completions :: <command-completion>);
  let names = map(project-name, open-projects());
  let compls =
    if (token)
      let string = as-lowercase(token-string(token));
      let compls = choose(rcurry(starts-with?, string), names);
      compls;
    else
      names;
    end;
  make-completion(param, token, complete-options: compls, exhaustive?: #t)
end method;

define class <dylan-project-parameter> (<command-parameter>)
end class;

define method node-complete (param :: <dylan-project-parameter>, parser :: <command-parser>, token :: false-or(<command-token>))
 => (completions :: <command-completion>);
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
  make-completion(param, token, complete-options: compls, exhaustive?: #t)
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

define method note-load-error
    (context :: <deft-context>, project :: <project-object>,
     handler-type == #"warning", message :: <string>)
 => ();
  format-err("%s", message);
end method note-load-error;

define method note-load-error
    (context :: <deft-context>, project :: <project-object>,
     handler-type == #"project-not-found", library-name :: <string>)
 => (filename :: false-or(<file-locator>))
  error("Could not find project '%s'.", library-name);
end method note-load-error;

define method note-load-error
    (context :: <deft-context>, project :: <project-object>,
     handler-type == #"project-file-not-found", filename :: <string>)
 => (filename :: false-or(<file-locator>))
  error("Could not find project file '%s'", filename);
end method note-load-error;

define function deft-open-project (project-name :: <string>) => (project)
  let (project, invalid?) = open-project-from-locator(as(<file-locator>, project-name));
  case
    project =>
      open-project-compiler-database
        (project,
         warning-callback: curry(note-load-warning, $deft-context, project),
         error-handler: curry(note-load-error, $deft-context, project));

      project.project-opened-by-user? := #t;

      dylan-current-project($deft-context) := project;

      project;
    invalid? =>
      error("Cannot open '%s' as it is not a project", project-name);
    otherwise =>
      error("Unable to open project '%s'", project-name);
  end
end;

define function deft-close-project (project :: <string>)
  let p = dylan-project($deft-context, project);
  if (p)
    close-project(p);
  else
    error("Project '%s' is not open.", project);
  end if;
end;

define command show project ($deft-commands)
  help "Show the specfied and open projects.";
  simple parameter project :: <string>,
    help: "The project to show. Defaults to the current project.",
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
  help "Open a project.";
  simple parameter project :: <string>,
    help: "The project to open. This should be in one of the registries. (`show registries`)",
    required?: #t,
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
  help "Close a project.";
  simple parameter project :: <string>,
    help: "The project to close.",
    required?: #t,
    node-class: <open-dylan-project-parameter>;
  implementation
    begin
      format-out("Closing %s!\n", project);
      deft-close-project(project);
    end;
end;
