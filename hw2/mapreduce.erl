-module(mapreduce) .
-export( [start/8] ).

% start("input_file.txt","output_file.txt",fun dna_char_count:map/1,
% 		fun dna_char_count:reduce/1,4,2,2,
% 		['workplace1@127.0.0.1','workplace2@127.0.0.1','workplace3@127.0.0.1'])
% $ erl -noshell name workplace1@127.0.0.1 -setcookie mapreduce

start (Fin, Fout, Mapf, Redf, Num_m, Num_s, Num_r, Nodes) ->
  io:format("Cool beans!~n"),
  make_host_file (Nodes),
  pool:start('P')
  %map_phase(mapf, fin, nodes)
  .


%map_phase(Mapf, Fin, Nodes) ->

%.


%spawn_nodes(Mapf, [H|T]) ->

%.


%% Generate host file from Node names
make_host_file(Nodes) ->
  {Result, File} = file:open( ".hosts.erlang", [write] ),
  lists:foreach( fun(X) -> file:write(File, string:join(["\'", X, "\'.\n" ], "") ) end, Nodes ).
