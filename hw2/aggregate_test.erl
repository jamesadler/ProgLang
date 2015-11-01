-module(aggregate_test).
-export([test/0]).

test() ->
  Aggregator = spawn( module_info(module), aggregate_results, [self(), []] ),
  receive
    _-> "Returned~n"
  end
.


aggregate_results(From, L) ->
	receive
		{ From, {Key, Val} } -> aggregate_results( From, [ L | {Key, Val} ] );
		'done' -> From ! {ok, L};
		_ -> exit("INVALID INPUT")
	end
.
