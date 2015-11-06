Contributors: Spencer Norris, James Adler


To invoke the mapreduce function:
  - Spin up worker nodes in separate terminals using 'erl -name NODE_NAME@HOST_NUM -setcookie COOKIE_NAME', using a common cookie for each
    - Compile the module containing the mapping and reducing functions you wish to invoke; do this for each node you start: c(mod_name) .
  - Start central process: 'erl -name central@127.0.0.1 -setcookie COOKIE_NAME'
  - From central terminal,
      - connect each worker node: 'net_kernel:connect_node('NODE_NAME@HOST_NUM'). '
      - Compile mapreduce: 'c(mapreduce).'
      - Compile mapping and reducing functions: 'c(MODULE_NAME).'
      -Invoke mapreduce:start/9,
        e.g. mapreduce:start("input.txt", "output.txt", MODULE_NAME,
          mapfunction, reducefunction, num_mappers, num_reducers, num_shufflers, ['n1@host1', 'n2@host2', etc.] ) .
        Host names MUST be atoms (enclosed in ''), will not parse correctly otherwise.
        Additionally, Host names must be exact matches for -name flag argument when starting nodes

    Note: could not implement with just 8 arguments, needed extra one to indicate source module of mapper and reducer functions;
      flaw is that it assumes both functions are in same module.
      In order to properly invoke mapreduce:start/9 on the functions 'mod_name:reduce/1'
