-module(mapreduce).
-export([start/8,map_phase/2,shuffle_phase/2,reduce_phase/2,loop/2]).

% start("input_file.txt","output_file.txt",fun dna_char_count:map/1,
% 		fun dna_char_count:reduce/1,4,2,2,
% 		['workplace1@127.0.0.1','workplace2@127.0.0.1','workplace3@127.0.0.1'])
% $ erl -noshell name workplace1@127.0.0.1 -setcookie mapreduce

% The Map Reduce framework expects a user-defined map and reduce function. 
% The map function must take a key-value pair as its argument and must return a list of key-value pairs. 
% The reduce function must take as its argument a pair whose first item is a key and second item a list 
% of values. The reduce function must return a pair consisting of a key followed by a list of values.

% The Map Reduce framework takes the user-defined map and reduce functions and goes through three phases: 
% a Map phase, a Shuffle phase, and a Reduce phase. 
% In the Map phase, an input file is split into multiple key-value pairs, 
% which are given to Mapper actors who call the user-defined map function on the provided input. 
% In the Shuffle phase, the Mappers sends the map results to Shuffler actors, 
% whose job is to aggregate the given list of key-value pairs into a key along with a list of values that 
% correspond to the key. Finally, in the Reduce phase, each Reducer actor is sent a key along with a list of 
% values and performs reduce to generate another list of values. In the end, the reducer results are written 
% to an output file.

% Input File, Output File, Map func, Reduce func, Num of Mappers,
% Num of Shufflers, Num of Reducers, List of Node names
start(Fin, Fout, Mapf, Redf, Num_m, Num_s, Num_r, Nodes) ->

	List = [[c, g, t, c],
             [g, c, a, g],
             [c, g, g, a],
             [t, c, c, a]],

	% register(mapreduceAtom, spawn(mapreduce, map_phase, [Device, Mapf, Redf])),
	Account = 0,
	ReducePhase = loop(Num_r,
		fun(_) -> spawn(mapreduce, reduce_phase, [Redf, Account]) end
	),

	MapPhase = loop(Num_m, 
		fun(_) -> spawn(mapreduce, map_phase, [Mapf, ReducePhase]) end
	),

	{ok, Device} = file:open(Fin,[read]),

	loop(4,
		fun(_) -> 
			case io:get_line(Device, "") of
				eof -> 
					file:close(Device), 
					io:format("End of File\n");
				Line -> 
					Tmp = string:tokens(Line, "\t"),
					Key = lists:nth(1,Tmp),
					Value = string:strip(lists:nth(2,Tmp), right, $\n),
					io:format("~w\n",[Value]),
					Map_proc = find_mapper(MapPhase)
					% io:format("~w\n",[Map_proc])
					% Map_proc ! {map, Extracted_line}
					% TmpMap = mapper:map({Key,Value}),
					
					% shuffle_phase(TmpMap, MappedData)
					% % map_phase(Device, Mapf, Redf)
			end
		end
	),

	% % %% Send the data to the mapper processes
	% Extract_func =
	% 	fun(N) ->
	% 		Extracted_line = lists:nth(N+1, List),
	% 		Map_proc = find_mapper(MapPhase),
	% 		% io:format("Send ~w to map process ~w~n",[Extracted_line, Map_proc]),
	% 		Map_proc ! {map, Extracted_line}
	% 	end,

	% loop(length(List),Extract_func),

	% % % Collect the result from all reducer processes
	% % io:format("Collect all data from reduce processes~n"),
	All_results =
		loop(length(ReducePhase),
			fun(N) -> collect(lists:nth(N+1, ReducePhase))
			end
		),
	lists:flatten(All_results),



	% ShufflePhase = loop(Num_s,
		% fun(_ -> spawn(mapreduce, shuffle_phase, [])))
	io:format("End of Cool Beans!~n")
.

loop(Max, Func) ->

	lists:map(Func, lists:seq(0,Max-1))
.

find_reducer(Processes, Key) ->
	Index = erlang:phash(Key, length(Processes)),
 	lists:nth(Index, Processes)
.

find_mapper(Processes) ->
	case random:uniform(length(Processes)) of
		0 ->
			find_mapper(Processes);
		N ->
			lists:nth(N, Processes)
	end
.

collect(Reduce_proc) ->
	Reduce_proc ! {collect, self()},
	receive
		{result, Result} ->
			Result
	end
.


map_phase(Mapf, ReducePhase) ->
	io:format("func: mapreduce\n"),

	receive
		{map, Data} ->
			Tmp = mapper:map(Data),
			% Tmp = Mapf(Data),
			lists:foreach(
				fun({K, V}) ->
					Reducer_proc =
						find_reducer(ReducePhase, K),
						Reducer_proc ! {reduce, {K, V}}
				end, 
				Tmp
			),

			map_phase(Mapf, ReducePhase)
	end
.

shuffle_phase(Data, MappedData) ->
	io:format("func: Shuffle\n")
.

reduce_phase(Redf, Account) ->
	io:format("func: reduce_phase\n"),
	receive
		{reduce, {K, V}} ->
			Account2 = case get(K) of
				undefined ->
		        	Account;
		        Current_acc ->
		        	Current_acc
		    end,
			% put(K, Redf(V, Account2)),
			% put(K, mapper:reduce(V, Account2)),
	 		reduce_phase(Redf, Account);
		{collect, PPid} ->
			PPid ! {result, get()},
		 	reduce_phase(Redf, Account)
	end
.
% Reads in each line of a file
% for_each_line(Device) ->
% 	case io:get_line(Device, "") of
%         eof  -> file:close(Device), io:format("End of File~n");
%         Line -> 
%         	Tmp = string:tokens(Line, "\t"),
%         	io:format("~s\n",[lists:nth(2,Tmp)])
%         	% for_each_line(Device)                	
%     end
% .

% Generate host file from Node names
make_host_file(Nodes) ->
  	{ok, Device} = file:open(".hosts.erlang", [write]),

  	lists:foreach(
  		fun(X) -> 
  			% Formats the host name to net_adm standards
  			file:write(Device, io_lib:format("\'~s\'.\n", [X])) 
  		end,
  		Nodes
  	),

  	file:close(Device)
.
