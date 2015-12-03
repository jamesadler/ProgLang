

puzzle([A, B, C, D, E, F, G, H, I]):-
  permutation([1, 2, 3, 4, 5, 6, 7, 8, 9], [A, B, C, D, E, F, G, H, I]),
  side(A, B, D),
  side(A, C, F),
  side(F, H, I),
  side(D, G, I),
  side(D, E, F).


side(A, B, C):-
  Z is A + B,
  plus(Z, C, 17).
