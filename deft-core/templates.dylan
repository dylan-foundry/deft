module: deft-core
synopsis:
copyright: See LICENSE file in this distribution.

// The <template> class is used to encapsulate constant format strings                                                                        
// ("templates") and its arguments.                                                                                                            

define class <template> (<object>)
  constant slot constant-string, required-init-keyword: constant-string:;
  constant slot arguments, init-keyword: arguments:, init-value: #();
  constant slot output-path, required-init-keyword: output-path:;
end class <template>;

define method as
    (class == <string>, template :: <template>) => (output :: <string>)
  apply(format-to-string, template.constant-string, template.arguments);
end method as;

define method print-object
    (template :: <template>, stream :: <stream>) => ()
  format(stream, "%s", as(<string>, template));
end method print-object;

define function write-templates (#rest templates :: <template>) => ();
  for (template in templates)
    with-open-file (stream = output-path(template), direction: #"output",
                    if-does-not-exist: #"create")
      print-object(template, stream);
    end with-open-file;
  end for;
end function write-templates;
