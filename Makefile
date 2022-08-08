EMACS := emacs
VERSION := $(shell sed -ne 's/^;; Version: \(.*\)/\1/p' buttercup.el)
ELISP_FILES := $(wildcard *.el)

.PHONY: test compile clean

all: test

test: test-buttercup test-docs

test-buttercup: compile
	./bin/buttercup -L . tests $(if $(CI),--traceback pretty)

test-docs: compile
	$(EMACS) -batch -L . -l buttercup.el -f buttercup-run-markdown docs/writing-tests.md

compile: $(patsubst %.el,%.elc,$(ELISP_FILES))

%.elc: %.el
	$(EMACS) -batch -L . -f batch-byte-compile $<

clean:
	rm -f *.elc tests/*.elc
