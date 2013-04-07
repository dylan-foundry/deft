module: deft
synopsis:
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define function main (name :: <string>, arguments :: <vector>)
  let global-args-parser = make(<command-line-parser>);

  block ()
    parse-command-line(global-args-parser, arguments,
                       description: "Deft: A Dylan Environment For Tools");
  exception (ex :: <help-requested>)
    exit-application(0);
  exception (ex :: <usage-error>)
    exit-application(2);
  end;

  exit-application(0);
end function main;

main(application-name(), application-arguments());
