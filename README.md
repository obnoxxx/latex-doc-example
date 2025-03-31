# latex-doc-example

This little project provides an example for how to create professional technical/scientific documents with the
[LaTeX](https://www.latex-project.org) typesetting system. Writing documents in LaTeX is a bit like programming:
you write a source code text file as input and "compile" it with the LaTeX processor to a rendered output format like ps or pdf. 

All that is needed to create a rendered pdf output document  (`doc.pdf` from the source code input file https://github.com/obnoxxx/latex-doc-example/blob/main/doc.tex is a computer with a LaTeX distribution installed, typically 
a Unix-like system like a Linux or MacOS  system with a tetex installation, but it should work on Windows , too.

For convenience, a Makefile is provided so that you don't need to memorize the exact latex commands.

Here is how to render the example doc:

```console

$ make doc

```

People who do not want to install the LaTeX tools on their host can use the
[buildbox](https://github.com/obnoxxx/buildbox/) project to render the slides in a container with a prebuilt container image.
Example:

``console

$ builbo -l latex -o ubuntu -0b -s "make doc"

``

this assumes that the `builbo` cli from the buildbox project is available in the host's `PATH`


The rendered pdf doc can also opened directly  directly in the preferred viewer application like so:

```console

$ make VIEWER=foobar show

```

The viewer could be `evince` on Linux and `open` on MacOS. 

Note that LaTeX can not only be used to create text documents but also for creating beautiful pdf slide decks using the `beamer` document class.

An eexample for such a LaTeX based presentation is available in a similar project: https://github.com/obnoxxx/latex-beamer-example











