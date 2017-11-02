# -*- mode: makefile -*-


LIB_SRCS := \
	Data/Tyme.hs \
	Data/Tyme/Types.hs


APP_SRCS := Main.hs


tangle = notangle -R'$@' $1 $< >$@


.SUFFIXES: .nw .pdf .tex
.nw.tex:
	noweave -filter btdefn -n -delay -index $< >$@
.tex.pdf:
	latexmk -shell-escape -pdf $<
	latexmk -c $<


all: \
Makefile \
.envrc \
.gitattributes \
.gitignore \
README.md \
ChangeLog.md \
LICENSE \
build \
tyme2invoice.pdf


build: \
$(addprefix src/,${LIB_SRCS}) \
$(addprefix app/,${APP_SRCS}) \
Setup.hs \
package.yaml \
shell.nix
	nix-build $(lastword $^) -o $@


.PHONY: clean
clean:
	find . \
	-type f \
	\! -path './.git*' \
	\! -name '*.nw' \
	\! -name invoice.cls \
	\! -name Makefile \
	-delete


Makefile: tyme2invoice.nw
	$(call tangle,-t2)


.envrc \
.gitattributes \
.gitignore \
ChangeLog.md \
README.md \
LICENSE \
package.yaml: \
tyme2invoice.nw
	$(call tangle,)


tyme2invoice.cabal: package.yaml
	nix-shell -p haskellPackages.hpack --run hpack


shell.nix: tyme2invoice.cabal
	nix-shell -p haskellPackages.cabal2nix --run 'cabal2nix --shell . >$@'


%.hs: tyme2invoice.nw
	$(call tangle,-filter btdefn)
