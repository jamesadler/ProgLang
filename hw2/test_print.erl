-module(test_print) .
-export([spoon_print/0]) .

spoon_print() ->
  receive
    _ ->
      io:format("Cool beans!~n")
  end.
