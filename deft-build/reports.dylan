module: deft-build
synopsis:
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define class <cli-report-type> (<cli-parameter>)
end class;

define method node-complete (param :: <cli-report-type>, parser :: <cli-parser>, token :: false-or(<cli-token>))
 => (completions :: <list>);
  let names = map(curry(as, <string>), key-sequence(available-reports()));
  let compls =
    if (token)
      let string = as-lowercase(token-string(token));
      choose(rcurry(starts-with?, string), names);
    else
      names;
    end;
  as(<list>, compls);
end method;

define cli-command report ($deft-cli)
  simple parameter report :: <symbol>,
    node-class: <cli-report-type>;
  named parameter project :: <string>,
    node-class: <cli-dylan-project>;
  named parameter format :: <symbol>,
    node-class: <cli-oneof>,
    alternatives: #("text", "dot", "html", "xml", "rst");
  implementation
    begin
      let p  = dylan-project($cli, project);
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
