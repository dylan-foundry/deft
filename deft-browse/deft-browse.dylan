module: deft-browse

define function print-type (project :: <project-object>, type)
  if (type)
    let type-id = environment-object-id(project, type);
    format-out(" :: %s", type-id.id-name);
  end if;
end function;

define method definition-id-name
    (project :: <project-object>, id :: <library-id>)
 => (id-name :: <string>)
  ""
end method;

define method definition-id-name
    (project :: <project-object>, id :: <module-id>)
 => (id-name :: <string>)
  id.id-library.id-name
end method;

define method definition-id-name
    (project :: <project-object>, id :: <definition-id>)
 => (id-name :: <string>)
  let module = id.id-module;
  concatenate(module.id-name, ":", module.id-library.id-name)
end method;

define method print-environment-object
    (project :: <project-object>, object :: <environment-object>)
  format-out("%s\n", environment-object-primitive-name(project, object));
end method;

define method print-environment-object
    (project :: <project-object>, object == #f)
  format-out("Object not found\n");
end method;

define method print-environment-object
    (project :: <project-object>, object :: <class-object>)
  let id = environment-object-id(project, object);
  let class-name = id.id-name;
  format-out("%s", class-name);
  let superclasses = class-direct-superclasses(project, object);
  if (~empty?(superclasses))
    superclasses := map(method (c) id-name(environment-object-id(project, c)) end, superclasses);
    format-out(" (%s)", join(superclasses, ", "));
  end if;
  format-out("\t[%s]\n", definition-id-name(project, id));
  let slots = class-slots(project, object);
  if (~empty?(slots))
    map(curry(print-environment-object, project), slots);
  end if;
end method;

define method print-environment-object
    (project :: <project-object>, object :: <slot-object>)
  let cons
    = if (~slot-setter(project, object))
        "constant "
      else
        ""
      end;
  format-out("  %sslot %s", cons, slot-init-keyword(project, object));
  let type = slot-type(project, object);
  // can't call print-environment-object on type because it's a class
  print-type(project, type);
  format-out("\n");
end method;

define method print-environment-object
    (project :: <project-object>, object :: <method-object>)
  // Why method-generic-function returns #f?
  print-environment-object(project, method-generic-function(project, object));
end method;

define method print-environment-object
    (project :: <project-object>, object :: <generic-function-object>)
  for (meth in generic-function-object-methods(project, object))
    format-out("%s\n", environment-object-display-name(project, meth, #f));
  end for;
end method;

define method print-environment-object
    (project :: <project-object>, object :: <constant-object>)
  let id = environment-object-id(project, object);
  format-out("constant %s", id.id-name);
  let type = variable-type(project, object);
  print-type(project, type);
  format-out("\t[%s]\n", definition-id-name(project, id));
end method;

define method print-environment-object
    (project :: <project-object>, object :: <variable-object>)
  let id = environment-object-id(project, object);
  format-out("variable %s", id.id-name);
  let type = variable-type(project, object);
  print-type(project, type);
  format-out("\t[%s]\n", definition-id-name(project, id));
end method;

define function inspect-dylan-object (name :: <string>)
  let project = dylan-current-project($deft-context);
  let library = project-library(project);
  let object = find-environment-object(project, name,
                                        library: library,
                                        module: first(library-modules(project, library)) );
  print-environment-object(project, object);
end function;

define command inspect ($deft-commands)
  help "Show something.";
  simple parameter dylan-object-name :: <string>,
    help: "the dylan object";
  implementation
    inspect-dylan-object(dylan-object-name);
end;
