module: deft-browse

define function print-type (project :: <project-object>, type)
  if (type)
    let type-id = environment-object-id(project, type);
    if (type-id)
      format-out(" :: %s", type-id.id-name);
    end if;
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
  format-out("Binding not found.\n");
end method;

define function definition-modifiers-string
    (project :: <project-object>, object :: <environment-object>)
 => (modifiers :: <string>)
  let modifiers = definition-modifiers(project, object);
  if (~empty?(modifiers))
    concatenate(join(modifiers, " ", key: curry(as, <string>)), " ")
  else
    ""
  end if
end function;

define method print-environment-object
    (project :: <project-object>, object :: <class-object>)
  let id = environment-object-id(project, object);
  let class-name = id.id-name;
  let modifiers = definition-modifiers-string(project, object);
  format-out("%s%s", modifiers, class-name);
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

define function function-parameter-to-string
    (project :: <project-object>, param :: <parameter>, #key with-type :: <boolean> = #t)
 => (string :: <string>)
    let type = parameter-type(param);
    let type-id = environment-object-id(project, type);
    let name = parameter-name(param);
    if (with-type & type-id)
      concatenate(name, " :: ", type-id.id-name)
    else
      name
    end if
end function;

define function function-signature
    (project :: <project-object>,
     object :: <dylan-function-object>)
 => (signature :: <string>)
  let parameter-to-string :: <function> = curry(function-parameter-to-string, project);
  let (required, rest, keys, all-keys?, next, values, rest-values)
    = function-parameters(project, object);
  let result :: <byte-string> = make(<byte-string>);
  result := concatenate(result, "(");
  result := concatenate(result, join(map(parameter-to-string, required), ", "));
  if (rest)
    result := concatenate(result, ", #rest ", parameter-to-string(rest));
  end;
  if (~empty?(keys))
    keys := map(parameter-to-string, keys);
    result := concatenate(result, ", #key ", join(keys, ", "));
  end;
  if (all-keys?)
    result := concatenate(result, ", #all-keys");
  end;
  result := concatenate(result, ") => (");
  result := concatenate(result, join(map(parameter-to-string, values), ", "));
  if (rest-values)
    result := concatenate(result, parameter-to-string(rest-values));
  end;
  result := concatenate(result, ")");
  result
end function;

define function print-function
    (project :: <project-object>,
     object :: <dylan-function-object>)
  let id = environment-object-id(project, object);
  let modifiers = definition-modifiers-string(project, object);
  format-out("%s%s %s", modifiers, id.id-name, function-signature(project, object));
  format-out("\t[%s]\n", definition-id-name(project, id));
end function;

define function print-method
    (project :: <project-object>,
     object :: <method-object>,
     parent :: false-or(<generic-function-object>))
  let id = environment-object-id(project, if (parent) parent else object end);
  let indent = if (parent) "  " else "" end;
  let modifiers = definition-modifiers-string(project, object);
  format-out("%s%s%s %s\n", indent, modifiers, id.id-name, function-signature(project, object));
end function;

define method print-environment-object
    (project :: <project-object>, object :: <method-object>)
  let generic = method-generic-function(project, object);
  if (generic)
    print-environment-object(project, method-generic-function(project, object));
  else
    print-method(project, object, #f);
  end if;
end method;

define method print-environment-object
    (project :: <project-object>, object :: <generic-function-object>)
  print-function(project, object);
  for (meth in generic-function-object-methods(project, object))
    print-method(project, meth, object);
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

define method print-environment-object
    (project :: <project-object>, object :: <macro-object>)
  let id = environment-object-id(project, object);
  // TODO: display the macro source definition?
  format-out("%smacro %s", definition-modifiers-string(project, object), id.id-name);
  format-out("\t[%s]\n", definition-id-name(project, id));
end method;

define function inspect-dylan-object (name :: <string>)
  let project = dylan-current-project($deft-context);
  if (project)
    let library = project-library(project);
    let object = find-environment-object(project, name,
                                          library: library,
                                          module: first(library-modules(project, library)) );
    print-environment-object(project, object);
  else
    format-out("No open project found.\n");
  end if
end function;

define command inspect ($deft-commands)
  help "Show something.";
  simple parameter dylan-object-name :: <string>,
    help: "the dylan object",
    required?: #t;
  implementation
    inspect-dylan-object(dylan-object-name);
end;
