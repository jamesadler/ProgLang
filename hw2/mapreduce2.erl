-module(mapreduce2).
-export([start/0,mapreduce2/1]).

start() ->
    register(addressbookAtom, spawn(mapreduce2, mapreduce2, [[]]))
  .

mapreduce2(Data) -> 
  io:format("mapreduce2\n")
  % receive
  %   {From, {addUser, Name, Email}} ->
  %      From ! {addressbook, ok},
  %      mapreduce2(add(Name, Email, Data));
  %   {From, {getName, Email}} ->
  %      From ! {addressbook, getname(Email, Data)},
  %      mapreduce2(Data);
  %   {From, {getEmail, Name}} ->
  %      From ! {addressbook, getemail(Name, Data)},
  %      mapreduce2(Data)
  % end
.

add(Name, Email, Data) ->
    case getemail(Name, Data) of
  undefined ->
      [{Name,Email}|Data];
  _ ->
      Data
    end.

getname(Email, [{Name, Email} | Data]) -> Name;
getname(Email, [_H | Data]) ->
    getname(Email, Data);
getname(_Email, []) ->
    undefined.

getemail(Name, [{Name, Email} | Data]) -> Email;
getemail(Name, [_H|Data]) ->
    getemail(Name, Data);
getemail(_Name, []) ->
    undefined.


%% Usage:
%
%  % erl -name addressbook@127.0.0.1 
%
% (addressbook@127.0.0.1)1> addressbook:start().
%
