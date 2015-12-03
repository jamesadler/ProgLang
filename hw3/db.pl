det(the).
det(a).
det(every).

det(did).
det(not).

noun(train).
noun(bike).
noun(flight).
noun(person).

verb(flew).
verb(left).
verb(arrived).
verb(stayed).

pres_verb(leave).
pres_verb(fly).
pres_verb(arrive).
pres_verb(stay).

np(X, Y):- X = det(D), Y = nom(noun(N)), det(D), nom(noun(N)).
vp(X):- X = verb(V), verb(V).
nom(X):- X = noun(N), noun(N).
s(X, Y):- X = np(D, N), Y = vp(V), np(D, N), vp(V).

%VERB MAPPINGS
maps(verb(left), pres_verb(leave)).
maps(verb(arrived), pres_verb(arrive)).
maps(verb(stayed), pres_verb(stay)).
maps(verb(flew), pres_verb(fly)).

%QUANTIFIERS
quantifier(a).
quantifier(every).

%ASSERTION PREDICATE
%assertion(nom(noun(N)), atom(Name), verb(V)).

%CONTRAPOSITIVE ASSERTIONS
parse(['the', W1, Name, 'did', 'not', W2, '.']):-
  A = nom(noun(W1)), A,
  B = pres_verb(W2), B,
  assert(assertion(A, Name, not(B))), !.

%POSITIVE ASSERTIONS
parse(['the', W1, Name, W2, '.']):-
  A = nom(noun(W1)), A,
  B = verb(W2), B,
  assert(assertion(A, Name, B)), !.

%QUERIES
parse(['did', W2, W3, W4, '?']):-
  quantifier(W2),
  nom(noun(W3)),
  pres_verb(W4),
  (query(W2, W3, W4)->
    write(yes);
    write(no)
  ).

query('a', N, PV):-
  maps(V, pres_verb(PV)),
  predicate_property(assertion(nom(noun(N)), _, V), visible), !.

query('every', N, PV):-
  maps(V, pres_verb(PV)),

  /*cannot be predicate saying person did not 'verb',*/
  not(predicate_property(assertion(nom(noun(N)), _, not(V)), visible)),

  /*Also cannot be the case...*/
  not(
      (
        /*that for a list L containing all the names of all nouns of type N...*/
        findall(X, predicate_property(assertion(nom(noun(N)), X, _), visible), L),

              /*there exists an element with name Var that has not done verb V*/
              member(Var, L),

              not(predicate_property(assertion(nom(noun(N)), Var, V), visible))
      )
  ), !.

loop :-
  read_line(L),
  (L \= ['.'], L \= ['!']),
  /*print_list(L),*/
  parse(L),
  loop.


read_line(Words) :- get0(C),
                    read_rest(C,Words).

/* A period or question mark ends the input. */
read_rest(46,['.']) :- !.
read_rest(63,['?']) :- !.

/* Spaces and newlines between words are ignored. */
read_rest(C,Words) :- ( C=32 ; C=10 ) , !,
                     get0(C1),
                     read_rest(C1,Words).

/* Commas between w;ords are absorbed. */
read_rest(44,[','|Words]) :- !,
                             get0(C1),
                             read_rest(C1,Words).

/* Otherwise get all of the next word. */
read_rest(C,[Word|Words]) :- lower_case(C,LC),
                             read_word(LC,Chars,Next),
                             name(Word,Chars),
                             read_rest(Next,Words).

/* Space, comma, newline, period or question mark separate words. */
read_word(C,[],C) :- ( C=32 ; C=44 ; C=10 ;
                         C=46 ; C=63 ) , !.

/* Otherwise, get characters, convert alpha to lower case. */
read_word(C,[LC|Chars],Last) :- lower_case(C,LC),
                                get0(Next),
                                read_word(Next,Chars,Last).

/* Convert to lower case if necessary. */
lower_case(C,C) :- ( C <  65 ; C > 90 ) , !.
lower_case(C,LC) :- LC is C + 32.


/* for reference ...
newline(10).
comma(44).
space(32).
period(46).
question_mark(63).
*/

