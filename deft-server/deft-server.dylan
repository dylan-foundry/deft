module: deft-server
synopsis:
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define variable *http-server* :: false-or(<http-server>) = #f;

define function deft-server-config () => (listeners :: <sequence>)
  // XXX: Read from config at some point.
  list("127.0.0.1:8888")
end;

define function deft-server-ensure-started ()
  if (~*http-server*)
    let listeners = deft-server-config();
    *http-server* := make(<http-server>,
                          listeners: listeners);
    start-server(*http-server*, background: #t);
    register-application-exit-function(deft-server-ensure-stopped);
  end if;
end;

define function deft-server-ensure-stopped ()
  if (*http-server*)
    stop-server(*http-server*);
    *http-server* := #f;
  end if;
end;

define function deft-server-add-resource
    (path :: <string>, resource :: <resource>)
 => ()
  add-resource(*http-server*, path, resource);
end;
