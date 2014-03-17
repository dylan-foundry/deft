module: deft-build
synopsis:
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define class <report-type-parameter> (<command-parameter>)
end class;

define method node-complete (param :: <report-type-parameter>, parser :: <command-parser>, token :: false-or(<command-token>))
 => (completions :: <command-completion>)
  let names = map(curry(as, <string>), key-sequence(available-reports()));
  let compls =
    if (token)
      let string = as-lowercase(token-string(token));
      choose(rcurry(starts-with?, string), names);
    else
      names;
    end;
  make-completion(param, token, complete-options: compls, exhaustive?: #t)
end method;

define command report ($deft-commands)
  simple parameter report :: <symbol>,
    node-class: <report-type-parameter>;
  named parameter project :: <string>,
    node-class: <dylan-project-parameter>;
  named parameter format :: <symbol>,
    node-class: <command-oneof>,
    alternatives: #("text", "dot", "html", "xml", "rst");
  implementation
    begin
      let p  = dylan-project($deft-context, project);
      let info = find-report-info(report);
      unless (format)
        format := #"text";
      end;
      case
        info =>
          if (~member?(format, info.report-info-formats))
            error("The %s report does not support the '%s' format",
                  report, format);
          end;
          let result = make(info.report-info-class,
                            project: p,
                            format: format);
          write-report(*standard-output*, result);
        otherwise =>
          error("No such report '%s'", report);
      end
    end;
end;
