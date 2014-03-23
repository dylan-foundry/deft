module: dylan-user
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define library deft-dfmc
  use common-dylan;
  use command-interface;
  use io;
  use serialization;
  use system;

  use deft-core;
  use deft-server;

  use dfmc-debug-back-end;
  use dfmc-definitions;
  use dfmc-flow-graph;

  use http-common;
  use http-server;

  export deft-dfmc;
end library;

define module deft-dfmc
  use common-dylan, exclude: { format-to-string };
  use command-interface;
  use format-out;
  use json-serialization;
  use locators;
  use print;
  use standard-io;
  use streams;

  use deft-core;
  use deft-server;

  use dfmc-debug-back-end;
  use dfmc-definitions, import: { <signature-spec> };
  use dfmc-flow-graph;

  use http-common, import: { quote-html };
  use http-server, import: {
    <directory-resource>,
    <sse-resource>,
    sse-push-event
  };
end module;
