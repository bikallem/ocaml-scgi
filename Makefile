build:
	dune build

fmt:
	dune build @fmt --auto-promote

tests: build
	dune runtest

clean:
	dune clean

utop: build
	dune utop src

install: build
	dune install scgi

uninstall: install
	dune uninstall scgi

.PHONY: build fmt tests clean utop install uninstall

