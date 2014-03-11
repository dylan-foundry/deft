module: deft-build
synopsis:
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define method deft-build-project (project :: <string>) => ()
  let p = dylan-project($cli, project);
  if (p)
    deft-build-project(p);
  end if;
end;

define method deft-build-project (project :: <project-object>) => ()
  format-out("Building project %s\n", project-name(project));
  if (build-project(project,
                    process-subprojects?: #t,
                    link?: #f,
                    save-databases?: #t,
                    progress-callback:    curry(note-build-progress, $cli, project),
                    warning-callback:     curry(note-compiler-warning, $cli, project),
                    error-handler:        curry(compiler-condition-handler, $cli)))
    link-project
      (project,
       build-script: default-build-script(),
       process-subprojects?: #t,
       progress-callback:    curry(note-build-progress, $cli, project),
       error-handler:        curry(compiler-condition-handler, $cli));
  end if;
end;

define method deft-clean-project (project :: <string>) => ()
  let p = dylan-project($cli, project);
  if (p)
    deft-clean-project(p);
  end if;
end;

define method deft-clean-project (project :: <project-object>) => ()
  format-out("Cleaning project %s\n", project-name(project));
  clean-project(project, process-subprojects?: #f);
end;

define cli-command build ($deft-cli)
  simple parameter project :: <string>,
    node-class: <cli-open-dylan-project>;
  implementation
    deft-build-project(project);
end;

define cli-command clean ($deft-cli)
  simple parameter project :: <string>,
    node-class: <cli-open-dylan-project>;
  implementation
    deft-clean-project(project);
end;


define variable *lastmsg* = #f;

define method note-build-progress
    (cli :: <dylan-cli>, project :: <project-object>,
     position :: <integer>, range :: <integer>,
     #key heading-label, item-label)
 => ();
  let last-item-label = *lastmsg*;
  if (item-label & ~empty?(item-label) & item-label ~= last-item-label)
    *lastmsg* := item-label;
    format-out("%s\n", item-label);
  end
end method note-build-progress;

define method note-compiler-warning
    (cli :: <dylan-cli>, project :: <project-object>,
     warning :: <warning-object>)
 => ();
  let stream = *standard-output*;
  new-line(stream);
  print-environment-object-name(stream, project, warning, full-message?: #t);
  new-line(stream)
end method note-compiler-warning;


define method compiler-condition-handler
    (context :: <dylan-cli>,
     handler-type == #"link-error", message :: <string>)
 => (filename :: singleton(#f))
  error("Link failed: %s", message)
end method compiler-condition-handler;

define method compiler-condition-handler
    (context :: <dylan-cli>,
     handler-type == #"link-warning", warning-message :: <string>)
 => (filename :: singleton(#f))
  format-out("%s\n", warning-message);
end method compiler-condition-handler;

define method compiler-condition-handler
    (context :: <dylan-cli>,
     handler-type == #"fatal-error", message :: <string>)
 => (filename :: singleton(#f))
  error("Fatal error: %s", message)
end method compiler-condition-handler;

define method compiler-condition-handler
    (context :: <dylan-cli>,
     handler-type :: <symbol>,
     warning-message :: <string>)
 => (yes? :: <boolean>)
  format-out("missing handler for %s: %s\n", handler-type, warning-message);
end method compiler-condition-handler;
