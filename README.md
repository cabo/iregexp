# iregexp
Tools for https://datatracker.ietf.org/doc/draft-ietf-jsonpath-iregexp

Create a parse tree:

```
$ iregexp -e "o.o|aa"
["alt", ["seq", "o", ["dot"], "o"], ["seq", "a", "a"]]
```

Convert to PCRE form:

```
$ iregexp  -tpcre -e "o.o|aa"
\A(?:o.o|aa)z
$ iregexp  -tpcre -e "(o.o|aa)"
\A(?:o.o|aa)z
```

Convert to ECMAScript (JavaScript) form:

```
$ iregexp  -tjs -e "o.o|aa"
^(?:o[^\n\r]o|aa)$
```

Get a number of (somewhat straitjacketed) examples:

```
$ iregexp  -texample -e "o.o|aa"
oao
obo
...
```

Get a random example:

```
$ iregexp  -trandom -e "o.o|aa"
o9o
$ iregexp  -trandom -e "o.o|aa"
aa
```

Run a small test set:

```
$ iregexp -l $(VISUAL=echo gem open iregexp)/test-data/simple.irl
...
=a                "a"
                  "a"
=🤔                "🤔"
                  "🤔"
-\                Expected one of [\(-\+], [\--\.], "?", [\[-\^], "n", "r", "t", [\{-\}] at line 1, column 2 (byte 2):
                  \
                  ~^
-\v               Expected one of [\(-\+], [\--\.], "?", [\[-\^], "n", "r", "t", [\{-\}] at line 1, column 2 (byte 2):
                  \v
                  ~^
=aa|bb+           ["alt", ["seq", "a", "a"], ["seq", "b", ["rep", 1, false, "b"]]]
                  "aa", "bb", "bbb", "bbbb", "bbbbb", "bbbbbb"
...
```

The test in the test set starts with "=" (test should be OK), "-"
(test should fail), and "*" (test should be OK, but regexp example
generator cannot handle this test ).
The JSON-like expression to the right of the example is a path tree.

[Tom Lord's excellent regexp example generator][regexp-examples] is
then used to generate a few examples.

[regexp-examples]: https://github.com/tom-lord/regexp-examples

Tests that should fail show a parser error message instead.

(Compare your output with test-data/simple.out.)

More docs to follow; until then lib/writer/iregexp-writer.rb is
probably the best explanation of the simple JSON-like parse tree syntax.
