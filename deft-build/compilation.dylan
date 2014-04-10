module: deft-build
synopsis:
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define variable *verbose?* :: <boolean> = #f;

define function load-default-target () => (project :: false-or(<project-object>))
  let config = deft-config();
  let default-target = element(config, "default-target", default: #f);
  if (default-target & instance?(default-target, <string>))
    deft-open-project(default-target)
  elseif (default-target)
    format-err("ERROR: default-target should be a string.\n");
    force-err();
    #f
  end if
end;

define method deft-build-project (project :: false-or(<string>)) => ()
  let p = dylan-project($deft-context, project);
  if (p)
    deft-build-project(p);
  else
    let p = load-default-target();
    if (p)
      deft-build-project(p);
    end if;
  end if;
end;

define method deft-build-project (project :: <project-object>) => ()
  format-out("Building project %s\n", project-name(project));
  force-out();
  if (build-project(project,
                    process-subprojects?: #t,
                    link?: #f,
                    save-databases?: #t,
                    progress-callback:    curry(note-build-progress, $deft-context, project),
                    warning-callback:     curry(note-compiler-warning, $deft-context, project),
                    error-handler:        curry(compiler-condition-handler, $deft-context)))
    link-project
      (project,
       build-script: default-build-script(),
       process-subprojects?: #t,
       progress-callback:    curry(note-build-progress, $deft-context, project),
       error-handler:        curry(compiler-condition-handler, $deft-context));
  end if;
end;

define method deft-clean-project (project :: false-or(<string>)) => ()
  let p = dylan-project($deft-context, project);
  if (p)
    deft-clean-project(p);
  end if;
end;

define method deft-clean-project (project :: <project-object>) => ()
  format-out("Cleaning project %s\n", project-name(project));
  clean-project(project, process-subprojects?: #f);
end;

define command build ($deft-commands)
  help "Build a project";
  simple parameter project :: <string>,
    help: "The project to build. If not specified, defaults to the current project.",
    node-class: <open-dylan-project-parameter>;
  implementation
    deft-build-project(project);
end;

define command clean ($deft-commands)
  help "Remove the build results from a project. This is not (currently) recursive.";
  simple parameter project :: <string>,
    help: "The project to clean. If not specified, defaults to the current project.",
    node-class: <open-dylan-project-parameter>;
  implementation
    deft-clean-project(project);
end;


define variable *last-heading-msg* = #f;
define variable *last-item-msg* = #f;

define method note-build-progress
    (context :: <deft-context>, project :: <project-object>,
     position :: <integer>, range :: <integer>,
     #key heading-label, item-label)
 => ();
  let last-heading-label = *last-heading-msg*;
  if (heading-label & ~empty?(heading-label) & heading-label ~= last-heading-label)
    *last-heading-msg* := heading-label;
    format-out("%s\n", heading-label);
    force-output(*standard-output*);
  end;
  if (*verbose?*)
    let last-item-label = *last-item-msg*;
    if (item-label & ~empty?(item-label) & item-label ~= last-item-label)
      *last-item-msg* := item-label;
      format-out("  %s\n", item-label);
      force-output(*standard-output*);
    end;
  end;
end method note-build-progress;

define method note-compiler-warning
    (context :: <deft-context>, project :: <project-object>,
     warning :: <warning-object>)
 => ();
  let stream = *standard-output*;
  new-line(stream);
  print-environment-object-name(stream, project, warning, full-message?: #t);
  new-line(stream);
  force-output(*standard-output*);
end method note-compiler-warning;


define method compiler-condition-handler
    (context :: <deft-context>,
     handler-type == #"link-error", message :: <string>)
 => (filename :: singleton(#f))
  error("Link failed: %s", message)
end method compiler-condition-handler;

define method compiler-condition-handler
    (context :: <deft-context>,
     handler-type == #"link-warning", warning-message :: <string>)
 => (filename :: singleton(#f))
  format-out("%s\n", warning-message);
  force-output(*standard-output*);
end method compiler-condition-handler;

define method compiler-condition-handler
    (context :: <deft-context>,
     handler-type == #"fatal-error", message :: <string>)
 => (filename :: singleton(#f))
  error("Fatal error: %s", message)
end method compiler-condition-handler;

define method compiler-condition-handler
    (context :: <deft-context>,
     handler-type :: <symbol>,
     warning-message :: <string>)
 => (yes? :: <boolean>)
  format-out("missing handler for %s: %s\n", handler-type, warning-message);
  force-output(*standard-output*);
end method compiler-condition-handler;
