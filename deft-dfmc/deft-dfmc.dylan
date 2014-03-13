module: deft-dfmc
synopsis:
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define command dfmc trace set ($deft-commands)
end;

define command dfmc trace show ($deft-commands)
end;

define command dfmc trace clear ($deft-commands)
  implementation
    begin
      *trace-dfm-callback* := #f;
      *trace-dfm-outputter* := #f;
      *trace-dfm-library* := #f;
      *trace-dfm-file* := #f;
      *trace-dfm-method* := #f;
    end;
end;
