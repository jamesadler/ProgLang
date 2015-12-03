

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
