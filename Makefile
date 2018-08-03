all:
	jbuilder build

tests:
	jbuilder runtest

clean:
	jbuilder clean

indent:
	ocp-indent -i src/*.ml
	ocp-indent -i src/*.mli
	ocp-indent -i samples/*.ml
	jbuilder build --dev

utop:
	jbuilder utop lib 

#all-supported-ocaml-versions:
#	$(JBUILDER) runtest --dev --workspace jbuild-workspace.dev

.PHONY: all tests clean check indent-build utop
