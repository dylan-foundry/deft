module: deft-dfmc
synopsis:
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define variable *dfmc-tracing-enabled?* :: <boolean> = #f;
define variable *dfmc-tracing-http-configured?* :: <boolean> = #f;

define constant $stream-resource = make(<sse-resource>);

define command dfmc trace set ($deft-commands)
  named parameter destination :: <symbol>,
    node-class: <oneof-node>,
    alternatives: #("text", "html");
  implementation
    begin
      *dfmc-tracing-enabled?* := #t;

      *trace-dfm-library* := #f;
      *trace-dfm-file* := #f;
      *trace-dfm-method* := #f;

      if (destination = #"text")
        *trace-dfm-callback* := write-to-standard-output;
        *trace-dfm-outputter* := out-text;
      else
        ensure-http-configured();
        *trace-dfm-callback* := write-to-event-stream;
        *trace-dfm-outputter* := out-html;
      end if;
      *trace-dfm-method-printer* := psp;
    end;
end;

define command dfmc trace show ($deft-commands)
  implementation
    begin
      if (*dfmc-tracing-enabled?*)
        format-out("DFMC tracing is enabled.\n");
      else
        format-out("DFMC tracing is disabled.\n");
      end if;
    end;
end;

define command dfmc trace clear ($deft-commands)
  implementation
    begin
      *dfmc-tracing-enabled?* := #f;
      *trace-dfm-callback* := #f;
      *trace-dfm-outputter* := #f;
      *trace-dfm-library* := #f;
      *trace-dfm-file* := #f;
      *trace-dfm-method* := #f;
    end;
end;

define function ensure-http-configured ()
  unless (*dfmc-tracing-http-configured?*)
    deft-server-ensure-started();
    deft-server-add-resource("/dfmc-tracing/events", $stream-resource);
    let exe-directory = locator-directory(as(<file-locator>, application-filename()));
    let base-directory = locator-directory(exe-directory);
    let share-directory = subdirectory-locator(base-directory, "share");
    let static-directory = subdirectory-locator(share-directory, "static");
    let tracing-directory = subdirectory-locator(static-directory, "dfmc-tracing");
    let static-resource = make(<directory-resource>,
                               directory: tracing-directory,
                               allow-directory-listing?: #f);
    deft-server-add-resource("/dfmc-tracing/", static-resource);
    *dfmc-tracing-http-configured?* := #t;
  end unless;
end;

define function write-to-standard-output (data)
  let encoded = write-object-to-json-string(list(as(<property-list>, data)));
  write(*standard-output*, encoded);
  new-line(*standard-output*);
end;

define method out-text (o :: <object>)
  block ()
    o.structured-output
  exception (c :: <condition>)
    let str = make(<byte-string-stream>, direction: #"output");
    print-object(o, str);
    str.stream-contents
  end;
end;

define method out-text (o :: <string>)
  o
end;

define function write-to-event-stream (data)
  let encoded = write-object-to-json-string(list(as(<property-list>, data)));
  sse-push-event($stream-resource, concatenate("data: ", encoded));
end;

define method out-html (o :: <object>)
  block ()
    o.structured-output.quote-html
  exception (c :: <condition>)
    let str = make(<byte-string-stream>, direction: #"output");
    print-object(o, str);
    str.stream-contents.quote-html
  end;
end;

define method out-html (o :: <string>)
  o.quote-html
end;

define function psp (o :: <signature-spec>)
  block ()
    let str = make(<byte-string-stream>, direction: #"output");
    print-specializers(o, str);
    str.stream-contents
  end;
end;
