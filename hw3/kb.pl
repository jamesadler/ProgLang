

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
vp(verb(X)).
nom(noun(X)).
