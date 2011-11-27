# automatra
an elementary cellular automata web service built on Sinatra

## usage

- `GET /:N.json` return a JSON-formatted trajectory of a rule `:N` automaton.
- `GET /:N.png` returns a PNG representation of a rule `:N` automaton.
- `GET /:N.txt` returns a plain-text representation of a rule `:N` automaton.

several `GET` parameters are available:

- `width=...` the number of cells in the model. takes an integer. defaults to 128. cannot be greater than 512.
- `initial=...` initial cellular state. can be either an integer, "random" for a random initial state, or "centered" for one 'on' cell surrounded by 'off' cells.
- `steps=...` the number of states to generate. takes an integer. usually, this should be the same as width. defaults to the model width. cannot be greater than 512.

for example, to generate a 512x512 PNG image of a rule 110 automaton with random input:
    GET /110.png?width=512&steps=512&initial=random

## contact

automatra was written by [Tom Jakubowski][crystae]. the source for automatra is available
on [GitHub][github], and a demonstration is running at [http://automatra-demo.herokuapp.com][demo].

[crystae]: http://crystae.net
[github]: http://github.com/tomjakubowski/automatra/
[demo]: http://automatra-demo.herokuapp.com/