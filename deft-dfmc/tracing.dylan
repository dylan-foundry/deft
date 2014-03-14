module: deft-dfmc
synopsis:
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define variable *dfmc-tracing-enabled?* :: <boolean> = #f;

define command dfmc trace set ($deft-commands)
  implementation
    begin
      *dfmc-tracing-enabled?* := #t;
      *trace-dfm-callback* := write-to-standard-output;
      *trace-dfm-outputter* := out-text;
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

define function psp (o :: <signature-spec>)
  block ()
    let str = make(<byte-string-stream>, direction: #"output");
    print-specializers(o, str);
    str.stream-contents
  end;
end;
