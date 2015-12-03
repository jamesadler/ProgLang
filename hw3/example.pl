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

%Important for queries
maps(verb(left), pres_verb(leave)).
maps(verb(arrived), pres_verb(arrive)).
maps(verb(stayed), pres_verb(stay)).
maps(verb(flew), pres_verb(fly)).

%CONTRAPOSITIVE ASSERTIONS
parse(['the', W1, _, 'did', 'not', W2, '.']):-
  A = nom(noun(W1)), A,
  B = verb(W2), B,
  assert(assertion(not(B), A)).

%POSITIVE ASSERTIONS
parse(['the', W1, _, W2, '.']):-
  A = nom(noun(W1)), A,
  B = verb(W2), B,
  write(assert(assertion(B, A))).

%QUERIES
%parse(['did', W2, W3, W4, '?']):-.
