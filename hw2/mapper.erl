-module(mapper).
-export([map/0, reduce/1, merge/0]).

% Maps the given data
% map() ->
map() ->
	receive
		{Caller, {Key, Value}} ->
			Caller ! {ok, lists:map( fun(X) -> {X,1} end, Value)};
		_->
			exit("ERROR: INVALID INPUT IN MAPPING FUNCTION~n")
end.

% Reduces the given data
reduce({Key,Values}) ->
	io:format("reduce")
	% {Key,[lists:foldl(fun(V,Sum) -> Sum + V end, 0, Values)]}
.

merge() ->
	receive
		_->
			io:format("merge~n")
	end.
