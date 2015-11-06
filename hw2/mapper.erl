-module(mapper).
-export([map/0, reduce/1, merge/0]).

% Maps the given data
<<<<<<< HEAD
% map() ->
map() ->
	receive
		{Caller, {Key, Value}} ->
			Caller ! {ok, lists:map( fun(X) -> {X,1} end, Value)};
		_->
			exit("ERROR: INVALID INPUT IN MAPPING FUNCTION~n")
end.
=======
% map({Key,Value}) -> 
% % map(Data) -> 
% 	lists:map(
%   		fun(X) -> 
%   			{X,1}
%   		end,
%   		Value
%   	)
% .

map({_,Value}) -> lists:map(fun(X) -> {X,1} end, Value).
>>>>>>> 22d4ea2f6277c257d533a62cdcb0a896af6ff2ac

% Reduces the given data
reduce({Key,Values}) ->
	io:format("reduce")
	% {Key,[lists:foldl(fun(V,Sum) -> Sum + V end, 0, Values)]}
.

<<<<<<< HEAD
merge() ->
	receive
		_->
			io:format("merge~n")
	end.
=======
merge(Key, Value, List) ->
	io:format("merge")
	%
.

fuck() ->
	io:format("fuck\n")
.
>>>>>>> 22d4ea2f6277c257d533a62cdcb0a896af6ff2ac
