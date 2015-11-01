-module(mapper).
-export([map/1,reduce/1]).

mapper_server() ->
	'central@127.0.0.1'
.

% mapreduce:start("input.txt", "output.txt", fun mapper:map/1, fun mapper:reduce/1, 4, 2, 2, ['ws1@127.0.0.1']).


call_mapreduce(Msg) ->
	MapReduceServer = mapper_server(),
	monitor_node(MapReduceServer, true)
	% io:format("~s", Msg)
.

% Maps the given data
% map({Key,Value}) -> 
map(Data) -> 
	lists:map(
  		fun(X) -> 
  			{X,1}
  		end,
  		Data
  	)
.

% Reduces the given data
reduce({Key,Values}) -> 
	io:format("reduce")
	% {Key,[lists:foldl(fun(V,Sum) -> Sum + V end, 0, Values)]}
.

merge(Key, Value, List) ->
	io:format("merge")
	%
.
