module: deft-deploy
author: Fabrice Leal
copyright: See LICENSE file in this distribution.

/*
 * Right now this only checks if the project is an executable or not
 * We could somehow check if our executable is a http-server, etc etc ...
 */
define function heroku-check ();
  let p = dylan-project($deft-context, #f);
  let type = project-target-type(p);
  if (type = #"executable")
    #t
  else
    format-out("heroku: Only executables are supported, this project is a %s", type);
    #f
  end if;
end function;

define command heroku check ($deft-commands)
  help "Check if a project can be deployed to heroku";
  implementation
    begin
      if (heroku-check())
	format-out("All seems ok.\n");
      end if;
    end;
end;

define function heroku-deploy ()
  let p = dylan-project($deft-context, #f);
  let exe-name = project-executable-name(p);
  let procfile :: <template>
    = make(<template>,
	   output-path: "Procfile",
	   constant-string: $heroku-file-template,
	   arguments: list(exe-name));
  
  write-templates(procfile);
end function;

define command heroku deploy ($deft-commands)
  help "Create a simple Procfile for the current project.";
  implementation
    begin
      if (heroku-check())
	heroku-deploy();
      end if;
    end;
end;

define function docker-deploy (version :: <string>);
  let p = dylan-project($deft-context, #f);
  let exe-name = project-build-filename(p);
  let procfile :: <template>
    = make(<template>,
	   output-path: "Dockerfile",
	   constant-string: $docker-file-template,
	   arguments: list(version, exe-name));
  
  write-templates(procfile);
end function;

define command docker deploy ($deft-commands)
  help "Create a simple Dockerfile for the current project";
  simple parameter version :: <string>,
    help: "For now either 2013.2 or latest";
  implementation
    begin
      docker-deploy(version);
    end;
end;
