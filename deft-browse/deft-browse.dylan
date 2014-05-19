module: deft-browse

define method print-object
    (project :: <project-object>, object :: <environment-object>)
  format-out("%=\n", object);
end method;

define method print-object
    (project :: <project-object>, object == #f)
  format-out("Object not found\n");
end method;

define method print-object
    (project :: <project-object>, object :: <class-object>)
  format-out("%s\n", environment-object-display-name(project, object, #f));
end method;

define method print-object
    (project :: <project-object>, object :: <method-object>)
  print-object(project, method-generic-function(project, object))
end method;

define method print-object
    (project :: <project-object>, object :: <generic-function-object>)
  for (meth in generic-function-object-methods(project, object))
    format-out("%s\n", environment-object-display-name(project, meth, #f));
  end for;
end method;

define function inspect-dylan-object (name :: <string>)
  let project = dylan-current-project($deft-context);
  let library = project-library(project);
  let object = find-environment-object(project, name,
                                        library: library,
                                        module: first(library-modules(project, library)) );
  print-object(project, object);
end function;

define command inspect ($deft-commands)
  help "Show something.";
  simple parameter dylan-object-name :: <string>,
    help: "the dylan object";
  implementation
    inspect-dylan-object(dylan-object-name);
end;
