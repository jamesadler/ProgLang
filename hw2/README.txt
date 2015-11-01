To invoke the mapreduce function:
  - Spin up worker nodes in separate terminals using 'erl -name NODE_NAME@HOST_NUM -setcookie COOKIE_NAME', using a common cookie for each
  - Start central process: 'erl -name central@127.0.0.1 -setcookie COOKIE_NAME'
  - From central terminal, connect each worker node: 'net_kernel:connect_node('NODE_NAME@HOST_NUM'). '
  -Invoke mapreduce:start/9,
    e.g. mapreduce:start("input.txt", "output.txt", Module_holding_mapfunction_and_reducefunction,
                          mapfunction, reducefunction, num_mappers, num_reducers, num_shufflers, ['n1@host1', 'n2@host2', etc.] ) .
    Host names MUST be atoms (enclosed in ''), will not parse correctly otherwise.
    
    Note: could not implement with just 8 arguments, needed extra one to indicate source module of mapper and reducer functions;
      flaw is that it assumes both functions are in same module
