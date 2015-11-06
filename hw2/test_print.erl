-module(test_print) .
-export([mapping/0, spoon_print/0]) .

spoon_print() ->
  receive
    _ ->
      io:format("Cool beans!~n")
  end.

  mapping() ->
  	receive
  		{Caller, {Key, Value}} ->
  			Caller ! lists:map( fun(X) -> {X,1} end, Value);
  		_->
  			exit("ERROR: INVALID INPUT IN MAPPING FUNCTION~n")
  	end.
