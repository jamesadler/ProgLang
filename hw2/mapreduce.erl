-module(mapreduce) .
-export( [start/8] ).

start (Fin, Fout, Mapf, Redf, Num_m, Num_s, Num_r, Nodes) ->
  io:format("Cool beans!~n"),
  make_host_file (Nodes)
  %map_phase(mapf, fin, nodes)
  .


%map_phase(Mapf, Fin, Nodes) ->

%.


%spawn_nodes(Mapf, [H|T]) ->

%.


%% Generate host file from Node names
make_host_file(Nodes) ->
  file:open( ".hosts.erlang", [read, write]),
  lists:foreach( fun(X) -> file:write("spoonfile.txt", string:join(["\'", X, "\'.~n" ], "") ) end, Nodes ).
