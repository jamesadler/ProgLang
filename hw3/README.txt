Contributors: Spencer Norris, James Adler

Please note the following when testing our implementation:
  - Many of the functions in db.pl and parse.pl overlap; as such,
    they should not both be loaded into the same instance of Prolog

  - Certain functions use built-ins specific to SWI-Prolog,
    and as such will likely only work under this implementation

  - Puzzle should be invoked as such:
      puzzle([A, B, C, D, E, F, G, H, I]).

  - parse and db must be started with command 'loop.'
      After this point, sentences should be able to be fed to each with no problem

  - The only functional issue that we're aware of at this time is that a global query
      (i.e. 'did every NOUN VERB?') will function as expected unless there are no
      assertions in the knowledge base yet (i.e. the user has not used 'the NOUN VERB.'
      or 'the NOUN did not VERB.' yet), in which case it will produce an Exception
