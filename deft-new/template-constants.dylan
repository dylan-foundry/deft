Module: deft-new

define constant $main-template-simple :: <string>
  = ("Module: %s\n"
     "Synopsis: \n"
     "Author: \n"
     "Copyright: See LICENSE file in this distribution.\n"
     "\n"
     "define function main (name :: <string>, arguments :: <vector>)\n"
     "  format-out(\"Hello, world!\\n\");\n"
     "  exit-application(0);\n"
     "end function main;\n"
     "\n"
     "main(application-name(), application-arguments());\n");

define constant $library-template-simple :: <string>
  = ("Module: dylan-user\n"
     "\n"
     "define library %s\n"
     "  use common-dylan;\n"
     "  use io;\n"
     "\n"
     "  export %s;\n"
     "end library;\n"
     "\n"
     "define module %s\n"
     "  use common-dylan, exclude: { format-to-string };\n"
     "  use format-out;\n"
     "end module;\n");

define constant $lid-template-simple :: <string>
  = ("Library: %s\n"
     "Target-Type: %s\n"
     "Files: %s\n"
     "       %s\n");

define constant $mit-license-template :: <string>
  = ("Copyright (c) 2014 XXXXXXX, YYYYYY.\n"
     "\n"
     "Permission is hereby granted, free of charge, to any person obtaining a\n"
     "copy of this software and associated documentation files (the \"Software\"),\n"
     "to deal in the Software without restriction, including without limitation\n"
     "the rights to use, copy, modify, merge, publish, distribute, sublicense,\n"
     "and/or sell copies of the Software, and to permit persons to whom the\n"
     "Software is furnished to do so, subject to the following conditions:\n"
     "\n"
     "The above copyright notice and this permission notice shall be included\n"
     "in all copies or substantial portions of the Software.\n"
     "\n"
     "THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS\n"
     "OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n"
     "FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n"
     "AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n"
     "LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING\n"
     "FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS\n"
     "IN THE SOFTWARE.\n");

define constant $gitignore-template :: <string>
 = ("_build\n"
    "*.hdp\n"
    "deft-package-local.json\n");
