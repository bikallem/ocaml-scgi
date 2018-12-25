default:
	dune build

build:
	dune build @fmt --auto-promote

tests: build
	dune runtest

clean:
	dune clean

utop: default
	dune utop src 

install: default
	dune install scgi

uninstall: install
	dune uninstall scgi 

.PHONY: default build tests clean utop install uninstall

