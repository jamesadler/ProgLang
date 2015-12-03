-module(mapreduce).
-export([start/9,map_phase/2,reduce_phase/2, aggregate_results/1]).

% start("input_file.txt","output_file.txt",fun dna_char_count:map/1,
% 		fun dna_char_count:reduce/1,4,2,2,
% 		['workplace1@127.0.0.1','workplace2@127.0.0.1','workplace3@127.0.0.1'])
% $ erl -noshell name workplace1@127.0.0.1 -setcookie mapreduce

% Helper Functions

% Loops a function X ammount of times
loop(Max, Func) ->
	lists:map(Func, lists:seq(0,Max-1))
.

% Input File, Output File, Map func, Reduce func, Num of Mappers,
% Num of Shufflers, Num of Reducers, List of Node names
start(Fin, Fout, FMod, Mapf, Redf, Num_m, Num_s, Num_r, Nodes) ->


	%Read in input file line by line, spawn mapper for each
	{ok, Device} = file:open(Fin,[read]),

	MappedData = mapping_phase(Device, Nodes, FMod, Mapf),

	% io:format("~w",[MappedData]),

	%SHUFFLE PHASE
	io:format("func: Shuffle\n"),

	% Tmp = [],
	% lists:foreach(
	% 	fun(X) ->
	% 		Key = element(1,X),
	% 		Value = element(2,X)

	% 		%mapper:merge(Key, Value,MappedData)

	% 	end,
	% 	MappedData
	% ),

	% lists:foreach(
	% 	fun(X) ->
	% 		Key = element(1,X),
	% 		Value = element(2,X),

	% 		io:format("~c ~w\n",[Key, Value])
	% 	end,
	% 	MappedData
	% ),


	io:format("func: end Shuffle\n"),




	% Lines = [],
	%Lines = read_line(Device, []),
	%io:format("~w",[Lines]),


	% Mapping Phase
	%lists:map( fun(X) -> spawn(X, ) end, Nodes),




	% register(mapreduceAtom, spawn(mapreduce, map_phase, [Device, Mapf, Redf])),

	% Account = 0,
	% ReducePhase = loop(Num_r,
	% 	fun(_) -> spawn(mapreduce, reduce_phase, [Redf, Account]) end
	% ),

  	io:format("End of Cool Beans!~n")
.

reduce_phase(Redf, Account) ->
	io:format("adf")
.

map_phase(Device, Redf) ->

	io:format("func: mapreduce\n"),

	MappedData = [],%[ {67,[]} ],%[{67,[]},{71,[]},{84,[]}],
	case io:get_line(Device, "") of
		eof -> file:close(Device), io:format("End of File\n");
		Line ->
			Tmp = string:tokens(Line, "\t"),
			Key = lists:nth(1,Tmp),
			Value = string:strip(lists:nth(2,Tmp), right, $\n),

			TmpMap = mapper:map({Key,Value})

		%	shuffle_phase(TmpMap, MappedData)
	end,


	io:format("fund: end map phase \n")
.


% Generate mappers from input file, distributing among nodes
mapping_phase(Device, Nodes, FMod, Mapf) ->

	%Create mapping functions on nodes w/ spawn_mappers,
	%Send results of spawn_mappers to Aggregator
	%Illustration of data transformation:
	%---> [{k, v}, {k, v}...] ===> [ {K1, [v1]}, {K2, [v1, v2, v3...]} ... ]

<<<<<<< HEAD

	Aggregator = spawn( module_info(module), aggregate_results, [[]] ),
	Times_called = spawn_mappers(Device, Nodes, 1, FMod, Mapf, self(), 0 ),
	io:format("in aggregator~n"),

	map_receive(Aggregator, Times_called),

	%Aggregator responds, sends list of tuples
	receive
		{ok, Res} ->
			lists:foreach(fun(X) -> io:format("~s~n", [lists:nth(1,X)]) end, Res),
			io:format("Done~n"),
		  { ok, Res }
		after 0 -> ok
	end.
=======
	spawn_mappers(Device, Nodes, 1, FMod, Mapf, self() )
	% Aggregator = spawn( module_info(module), aggregate_results, [self(), []] ),
	% io:format("in aggregator~n")
	% receive
	% 	{ok, {K, V} } ->
	% 		Aggregator ! {K, V}
	% 	after 0 -> Aggregator ! 'done', ok
	% end,

	% receive
	% 	{ok, [H|T] } -> Res = { ok, [H|T] }
	% end,

	% Res
.
>>>>>>> 22d4ea2f6277c257d533a62cdcb0a896af6ff2ac


spawn_mappers(Device, Nodes, Index, FMod, Mapf, Caller, Times_called) ->
	case io:get_line(Device, "") of

		%Catch end of file
		eof -> file:close(Device), io:format("End of File\n");

		%Extract key and values, spawn function on node
		%and pass it pair + pid of mapping_phase
		Line ->
			Tmp = string:tokens(Line, "\t"),
			Key = lists:nth(1,Tmp),
			Value = string:strip(lists:nth(2,Tmp), right, $\n),
			% io:format("~s\n",[lists:nth(Index, Nodes)]),
			% io:format("~s ~s\n",[Key, Value]),
			Pid = spawn(lists:nth(Index, Nodes), FMod, Mapf, [{Key,Value}] ),
			Pid ! { Caller, {Key, Value} },


			%Cycle through Nodes to distribute workload
			case length(Nodes) =:= Index of
				true -> spawn_mappers(Device, Nodes, 1, FMod, Mapf, Caller, Times_called + 1);
				false -> spawn_mappers(Device, Nodes, Index + 1, FMod, Mapf, Caller, Times_called + 1)
			end
	end,
	Times_called + 1.

%Calls aggregate_helper in case of valid input;
%Pulls key-value pairs from L, returns a list of keys
aggregate_results(Record) ->
	receive
		{Caller, [H | T] } ->
				aggregate_results( aggregate_helper( [H | T], Record ) );
		{Caller, 'done'} -> Caller ! {ok, Record};
		_ -> exit("INVALID INPUT")
	end
.

%Programmatically equivalent to shuffle phase
aggregate_helper(L, Res) ->

	case L of

		%Find tuple in results;
		%If present, adjust value list;
		%Otherwise insert new tuple
		[ {K, V} | T ] ->
				aggregate_helper(T, lists:keystore(K, 1, Res, {K, [L | V] }));
		[] -> Res;
		_ -> exit("ERROR: INVALID INPUT LIST~n")
	end.

map_receive(Aggregator, Times_called) ->
	receive
		{ok, L} ->
			io:format("Cool~n"),
			lists:foreach( fun(x) -> io:format("~s~n", [lists:nth(1, x)]) end, L),
			Aggregator ! {self(), L},
			case Times_called of
				0 -> ok;
				_-> map_receive(Aggregator, Times_called - 1)
			end;

		_-> exit("ERROR: UNEXPECTED INPUT~n")
	end.
