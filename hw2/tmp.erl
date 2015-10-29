-module(mapreduce).
-export([start/8,map_phase/3,shuffle_phase/2]).

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
	io:format("Start of Cool beans!~n~n"),
	make_host_file(Nodes),
	{ok, Device} = file:open(Fin,[read]),

	register(mapreduceAtom, spawn(mapreduce, map_phase, [Device, Mapf, Redf])),
  	
  	io:format("End of Cool Beans!~n")
.

%map_phase(Mapf, Fin, Nodes) ->.

% spawn_nodes(Mapf, [H|T]) ->
map_phase(Device, Mapf, Redf) ->
	
	io:format("func: mapreduce\n"),

	MappedData = [],%[ {67,[]} ],%[{67,[]},{71,[]},{84,[]}],
	case io:get_line(Device, "") of
		eof -> file:close(Device), io:format("End of File\n");
		Line -> 
			Tmp = string:tokens(Line, "\t"),
			Key = lists:nth(1,Tmp),
			Value = string:strip(lists:nth(2,Tmp), right, $\n),

			TmpMap = mapper:map({Key,Value}),
			% io:format("~W~n", [TmpMap,1])
			% io:format("~s!~n", [lists:nth(2,Tmp)]),
			% io:format("~W~n", [lists:nth(1, TmpMap),2])
			% io:format("{~s, ~s}\n",[Key, Value])
			% MappedData = lists:append(MappedData, TmpMap),
			% io:format("{~s, ~s}\n",[Key, Value])
			% lists:foreach(
			% 	fun(X) ->
			% % 		io:format("~w\n",[X]),
			% 		Key2 = element(1,X),
			% 		Value2 = element(2,X),

			% 		case lists:keyfind(Key2, 1, MappedData) of
			% 			{Key2, Index} ->
			% 				MappedData;
			% 			false ->
			% 				[{Key2, [Value2]} | MappedData]
			% % 				io:format("~s, ~s\n", [Key2, Index]);

			% % 		% % 		% lists:keymerge(1, {Key, Index}, )
			% % 		% % 		% lists:append(Index, [Value]),
			% % 		% % 		io:format("~w~n", [Index]);
			% % 		% % 		% Index = lists:append(Index, [Value]),
			% % 		% % 		% io:format("~w~n", [Index]);
			% % 			false -> 
			% % 				io:format("Doesn't exist: ~w\n",[Key2]),
			% % 				% TmpMapped = [{Key2, [Value2]} | MappedData],
			% % 				% MappedData = TmpMapped,
			% % 				io:format("~w\n", MappedData)
			% % 				% MappedData = [{Key2, [Value2]} | MappedData]
			% % 				% MappedData = lists:append([{Key2, [Value]}], MappedData)
			% 		end
			% % 		% io:format("~W~n", [X,3])
			% % 		% io:format("~s\n",[Key])
			% 	end,
			% 	TmpMap
			% ),
			shuffle_phase(TmpMap, MappedData)
			% map_phase(Device, Mapf, Redf)
	end,


	io:format("fund: end mapreduce\n")
.

shuffle_phase(Data, MappedData) ->
	io:format("func: Shuffle\n"),

	Tmp = [],
	lists:foreach(
		fun(X) ->
			Key = element(1,X),
			Value = element(2,X),

			mapper:merge(Key, Value,MappedData)

	% 		case lists:keyfind(Key, 1, MappedData) of
	% 			{Key, Index} -> 
	% 				io:format("~s, ~s\n", [Key, Index]);
	% 		% 		% lists:keymerge(1, {Key, Index}, )
	% 		% 		% lists:append(Index, [Value]),
	% 		% 		io:format("~w~n", [Index]);
	% 		% 		% Index = lists:append(Index, [Value]),
	% 		% 		% io:format("~w~n", [Index]);
	% 			false -> 
	% 				io:format("Doesn't exist\n")
	% 				% lists:append([{Key, [Value]}], MappedData)
	% 		end
	% 		% io:format("~c\n",[Key])
		end,
		Data
	),

	lists:foreach(
		fun(X) ->
			Key = element(1,X),
			Value = element(2,X),

			io:format("~c ~w\n",[Key, Value])
		end,
		MappedData
	),


	io:format("func: end Shuffle\n")
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
