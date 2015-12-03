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


parse(['the', W1, W2, 'did', 'not', W3, '.']):-
  A = nom(noun(W1)),
  assert(neg(W3(W2)))
  .


parse(['the', W2, W3, W4, '.']):-
  B = nom(noun(W2)), B,
  assert(word(W3)),
  D = verb(W4), D,
  listing(word).

%parse(['did', W2, W3, W4, '?']):-.
