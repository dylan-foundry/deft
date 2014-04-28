Module: deft-new
Synopsis: A command to create the initial boilerplate for new Dylan libraries.
Copyright: Original Code is Copyright (c) 2012 Dylan Hackers. All rights reserved.
License: See License.txt in this distribution for details.
Warranty: Distributed WITHOUT WARRANTY OF ANY KIND

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

define function create-directory?
    (directory :: <directory-locator>, subdirectory-name :: <string>)
 => (subdirectory :: <directory-locator>)
  let subdirectory = subdirectory-locator(directory, subdirectory-name);
  if (file-exists?(subdirectory))
    subdirectory
  else
    create-directory(directory, subdirectory-name)
  end if
end;

define function make-dylan-app (app-name :: <string>, #key type) => ()
  let project-dir = create-directory?(working-directory(), app-name);

  local method to-target-path (#rest args) => (target)
          merge-locators(as(<file-locator>, apply(concatenate, args)),
                         project-dir);
        end method to-target-path;

  let main-template-text
    = if (type == #"executable")
        $main-executable-template-simple
      else
        $main-dll-template-simple
      end if;

  let main :: <template>
    = make(<template>,
           output-path: to-target-path(app-name, ".dylan"),
           constant-string: main-template-text,
           arguments: list(app-name));
  let lib :: <template>
    = make(<template>,
           output-path: to-target-path("library.dylan"),
           constant-string: $library-template-simple,
           arguments: list(app-name, app-name, app-name, app-name, app-name));
  let lid :: <template>
    = make(<template>,
           output-path: to-target-path(app-name, ".lid"),
           constant-string: $lid-template-simple,
           arguments: list(app-name, type, "library", app-name));
  let license :: <template>
    = make(<template>,
           output-path: to-target-path("LICENSE"),
           constant-string: $mit-license-template,
           arguments: list());
  let gitignore :: <template>
    = make(<template>,
           output-path: to-target-path(".gitignore"),
           constant-string: $gitignore-template,
           arguments: list());

  let test-entries
    = if (type == #"dll")
        format-to-string("    \"%s-test-suite-app\"\n", app-name)
      else
        ""
      end if;

  let deft-package-json :: <template>
    = make(<template>,
           output-path: to-target-path("deft-package.json"),
           constant-string: $deft-package-json-template,
           arguments: list(app-name, app-name, test-entries));
  let test-suite-app-library :: <template>
    = make(<template>,
           output-path: to-target-path("tests/", format-to-string("%s-test-suite-app-library.dylan", app-name)),
           constant-string: $test-suite-app-library-template,
           arguments: list(app-name, app-name, app-name, app-name));
  let test-suite-app :: <template>
    = make(<template>,
           output-path: to-target-path("tests/", format-to-string("%s-test-suite-app.dylan", app-name)),
           constant-string: $test-suite-app-template,
           arguments: list(app-name, app-name, app-name, app-name));
  let test-suite-app-lid :: <template>
    = make(<template>,
           output-path: to-target-path("tests/", format-to-string("%s-test-suite-app.lid", app-name)),
           constant-string: $test-suite-app-lid-template,
           arguments: list(app-name, app-name, app-name, app-name));
  let test-suite-library :: <template>
    = make(<template>,
           output-path: to-target-path("tests/", format-to-string("%s-test-suite-library.dylan", app-name)),
           constant-string: $test-suite-library-template,
           arguments: list(app-name, app-name, app-name, app-name, app-name, app-name));
  let test-suite :: <template>
    = make(<template>,
           output-path: to-target-path("tests/", format-to-string("%s-test-suite.dylan", app-name)),
           constant-string: $test-suite-template,
           arguments: list(app-name, app-name, app-name));
  let test-suite-lid :: <template>
    = make(<template>,
           output-path: to-target-path("tests/", format-to-string("%s-test-suite.lid", app-name)),
           constant-string: $test-suite-lid-template,
           arguments: list(app-name, app-name, app-name));

  write-templates(main, lib, lid, license, gitignore, deft-package-json);
  write-registry(project-dir, app-name);

  if (type == #"dll")
    let test-dir = create-directory?(project-dir, "tests");
    write-templates(test-suite-app-library, test-suite-app, test-suite-app-lid, test-suite-library, test-suite, test-suite-lid);
    write-registry(project-dir, format-to-string("%s-test-suite", app-name), 
                   registry-entry-prefix: "tests/");
    write-registry(project-dir, format-to-string("%s-test-suite-app", app-name), 
                   registry-entry-prefix: "tests/");
  end if;
end function make-dylan-app;

define function write-registry
    (directory :: <directory-locator>, name :: <string>, #key registry-entry-prefix :: <string> = "")
  let registry = create-directory?(directory, "registry");
  let generic = create-directory?(registry, "generic");
  with-open-file (stream = merge-locators(as(<file-locator>, name), generic),
                  direction: #"output",
                  if-does-not-exist: #"create")
    format(stream, "abstract://dylan/%s%s.lid\n", registry-entry-prefix, name)
  end with-open-file;
end;

define function is-valid-dylan-name? (word :: <string>) => (name? :: <boolean>)
  local method leading-graphic? (c)
          member?(c, "!&*<>|^$%@_")
        end;
  local method special? (c)
          member?(c, "-+~?/")
        end;
  local method is-name? (c :: <character>) => (name? :: <boolean>)
          alphanumeric?(c) | leading-graphic?(c) | special?(c)
        end method is-name?;

  every?(is-name?, word) &
  case
    alphabetic?(word[0]) => #t;
    decimal-digit?(word[0])
      => block (return)
           for (i from 1 below word.size - 1)
             if (alphabetic?(word[i]) & alphabetic?(word[i + 1]))
               return(#t)
             end if;
           end for;
         end block;
    leading-graphic?(word[0]) => (word.size > 1) & any?(alphabetic?, word);
  end case;
end function is-valid-dylan-name?;

define function generate-project (project-name :: <string>, #key type)
  if (is-valid-dylan-name?(project-name))
    block ()
      make-dylan-app(project-name, type: type);
    exception (condition :: <condition>)
      error("%=", condition);
    end block;
  else
    error("Invalid name! Please use a valid Dylan library name.");
  end if;
end;

define command new application ($deft-commands)
  help "Create a skeleton application project.";
  simple parameter project-name :: <string>,
    help: "The name of the project to create.";
  implementation
    begin
      generate-project(project-name, type: #"executable");
    end;
end;

define command new library ($deft-commands)
  help "Create a skeleton library project.";
  simple parameter project-name :: <string>,
    help: "The name of the project to create.";
  implementation
    begin
      generate-project(project-name, type: #"dll");
    end;
end;
