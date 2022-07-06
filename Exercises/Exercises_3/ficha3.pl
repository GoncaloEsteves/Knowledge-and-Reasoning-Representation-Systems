%----------------------------------------------------------------------
% i) Extensao do predicado pertence : Lista, Valor -> {V, F}

pertence([H|T], H).
pertence([H|T], X) :- pertence(T, X).

%----------------------------------------------------------------------
% ii) Extensao do predicado comprimento : Lista, Numero -> {V, F}

comprimento([], 0).
comprimento([H|T], X) :- comprimento(T, R), X is R+1.

%----------------------------------------------------------------------
% iii) Extensao do predicado diferentes : Lista, Valor -> {V, F}

diferentes([], 0).
diferentes([H|T], X) :- pertence(T, H), !, diferentes(T, X).
diferentes([H|T], X) :- diferentes(T, A), X is A+1.

%----------------------------------------------------------------------
% iv) Extensao do predicado apaga1 : Valor, Lista, Lista -> {V, F}.

apaga1(X, [], []).
apaga1(X, [X|T], T).
apaga1(X, [H|T], [H|A]) :- apaga1(X, T, A).

%----------------------------------------------------------------------
% v) Extensao do predicado apagaT : Valor, Lista, Lista -> {V, F}.

apagaT(X, [], []).
apagaT(X, [X|T], A) :- apagaT(X, T, A), !.
apagaT(X, [H|T], [H|A]) :- apagaT(X, T, A), !.

%----------------------------------------------------------------------
% vi) Extensao do predicado adicionar : Valor, Lista, Lista -> {V, F}.

adicionar(X, [], [X]).
adicionar(X, [X|T], [X|T]).
adicionar(X, [H|T], [H|A]) :- adicionar(X, T, A).

%----------------------------------------------------------------------
% vii) Extensao do predicado concatenar : Lista, Lista, Lista -> {V, F}.

concatenar([], [], []).
concatenar([], L, L).
concatenar(L, [], L).
concatenar([H|T], X, [H|L]) :- concatenar(T, X, L).

%----------------------------------------------------------------------
% viii) Extensao do predicado inverter : Lista, Lista -> {V, F}.

ultimoElem(X, [X]).
ultimoElem(X, [H|T]) :- ultimoElem(X, T).

removeUltimo([], []).
removeUltimo([X], []).
removeUltimo([H|T], [H|B]) :- removeUltimo(T, B).

inverter([], []).
inverter([H|T], L) :- ultimoElem(H, L), removeUltimo(L, X), inverter(T, X).

%----------------------------------------------------------------------
% ix) Extensao do predicado sublista : Lista, Lista -> {V, F}.

sublista([], _).
sublista([H|T], [H|X]) :- sublista(T, X).
sublista([A|L], [H|T]) :- pertence(T, A), sublista(L, T).

%----------------------------------------------------------------------
% x) 