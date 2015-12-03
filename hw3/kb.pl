

det(the).
det(a).
det(every).

noun(train).
noun(bike).
noun(flight).
noun(person).

verb(flew).
verb(left).
verb(arrived).
verb(stayed).


np(X, Y):- X = det(D), Y = noun(N), det(D), noun(N).
vp(X):- X = verb(V), verb(V).
nom(X):- X = noun(N), noun(N).
s(X, Y):- X = np(D, N), Y = vp(V), np(D, N), vp(V).

print_list([]).
print_list([H|T]):- nl, write(H), print_list(T).

parse([W1, W2, W3, '.']):- NP = np(W1, W2), VP = vp(W3), s(NP, VP).

loop :-
  read_line(L),
  (L \= ['.'], L \= ['!']),
  print_list(L),
  /*parse(L),*/
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
