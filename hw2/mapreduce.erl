-module(mapreduce).
-export([start/9,map_phase/2,reduce_phase/2]).

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

	%SHUFFLE PHASE
	io:format("func: Shuffle\n"),

	Tmp = [],
	lists:foreach(
		fun(X) ->
			Key = element(1,X),
			Value = element(2,X)

			%mapper:merge(Key, Value,MappedData)

		end,
		MappedData
	),

%	lists:foreach(
%		fun(X) ->
%			Key = element(1,X),
%			Value = element(2,X),
%
%			io:format("~c ~w\n",[Key, Value])
%		end,
%		MappedData
%	),


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

read_line(Device, Lines) ->
	case io:get_line(Device, "") of
		eof ->
			file:close(Device),
			io:format("End of File\n");
		Line ->
			Tmp = string:tokens(Line, "\t"),
			Key = lists:nth(1,Tmp),
			Value = string:strip(lists:nth(2,Tmp), right, $\n),
			% put(Lines, [[Value] | Lines]),
			% [[Value] | Lines],
			% io:format("~w\n",[Value])
			% [Value],
			% TmpMap = mapper:map({Key,Value}),

			% shuffle_phase(TmpMap, MappedData)
			% % map_phase(Device, Mapf, Redf)
			read_line(Device, [[Value] | Lines])
	end
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

%{ok, Device} = file:open(".hosts.erlang", [write]),
% Formats the host name to net_adm standards
%file:write(Device, io_lib:format("\'~s\'.\n", [X])),

	spawn_mappers(Device, Nodes, 1, FMod, Mapf, self() ),
	Aggregator = spawn( module_info(module), aggregate_results, [self(), []] ),
		io:format("in aggregator~n"),
	receive
		{ok, {K, V} } ->
			Aggregator ! {K, V}
		after 0 -> Aggregator ! 'done', ok
	end,

	receive
		{ok, [H|T] } -> Res = { ok, [H|T] }
	end,

	Res.


spawn_mappers(Device, Nodes, Index, FMod, Mapf, Caller) ->
	case io:get_line(Device, "") of

		%Catch end of file
		eof -> file:close(Device), io:format("End of File\n");

		%Extract key and values, spawn function on node
		%and pass it pair + pid of mapping_phase
		Line ->
			Tmp = string:tokens(Line, "\t"),
			Key = lists:nth(1,Tmp),
			Value = string:strip(lists:nth(2,Tmp), right, $\n),
			Pid = spawn( lists:nth(Index, Nodes), FMod, Mapf, [] ),
			Pid ! { Caller, {Key, Value} },

			%Cycle through Nodes to distribute workload
			case length(Nodes) =:= Index of
				true -> spawn_mappers(Device, Nodes, 1, FMod, Mapf, Caller);
				false -> spawn_mappers(Device, Nodes, Index + 1, FMod, Mapf, Caller)
			end
	end.


aggregate_results(From, L) ->
	receive
		{ From, {Key, Val} } -> aggregate_results( From, [ {Key, Val} | L ] );
		'done' -> From ! {ok, L}, ok;
		_ -> exit("INVALID INPUT")
	end
.
