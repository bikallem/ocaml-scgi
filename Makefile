all:
	dune build

tests:
	dune runtest

clean:
	dune clean

indent:
	ocp-indent -i src/*.ml
	ocp-indent -i src/*.mli
	ocp-indent -i samples/*.ml
	dune build --dev

utop:
	dune utop lib 

.PHONY: all tests clean check indent-build utop
