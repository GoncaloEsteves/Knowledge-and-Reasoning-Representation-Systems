% ---------------------------------------------------------------------------------------
% i) Extensao do predicado somadois: Valor, Valor, Resultado -> {V, F}

somadois(X, Y, R) :- R is X+Y.

% ---------------------------------------------------------------------------------------
% ii) Extensao do predicado somatres: Valor, Valor, Valor, Resultado -> {V, F}

somatres(X, Y, Z, R) :- somadois(X, Y, A), somadois(A, Z, R).

% ---------------------------------------------------------------------------------------
% iii) Extensao do predicado somavalores : Lista, Resultado -> {V, F}

somavalores([], 0).
somavalores([H|T], R) :- somavalores(T, A), R is H+A.

% ---------------------------------------------------------------------------------------
% iv) Extensao do predicado oparit : Valor, Valor, Operacao -> {V, F}

oparit(X, Y, +, R) :- R is X+Y.
oparit(X, Y, -, R) :- R is X-Y.
oparit(X, Y, *, R) :- R is X*Y.
oparit(X, Y, /, R) :- R is X/Y.

% ---------------------------------------------------------------------------------------
% v) Extensao do predicado oparitlista : Lista, Operacao, Resultado -> {V, F}

oparitlista([], +, 0).
oparitlista([], *, 1).
oparitlista([H|T], +, R) :- oparitlista(T, +, A), R is H+A.
oparitlista([H|T], *, R) :- oparitlista(T, *, A), R is H*A.

% ---------------------------------------------------------------------------------------
% vi) Extensao do predicado maiordois : Valor, Valor, Resultado -> {V, F}

maiordois(X, Y, X) :- X>=Y.
maiordois(X, Y, Y) :- X<Y.

% ---------------------------------------------------------------------------------------
% vii) Extensao do predicado maiortres : Valor, Valor, Valor, Resultado -> {V, F}

maiortres(X, Y, Z, X) :- X >= Y, X >= Z.
maiortres(X, Y, Z, Y) :- Y >= X, Y >= Z.
maiortres(X, Y, Z, Z) :- Z >= X, Z >= Y.

% ---------------------------------------------------------------------------------------
% viii) Extensao do predicado maiorlista : Lista, Resultado -> {V, F}

maiorlista([], -1).
maiorlista([H], H).
maiorlista([H|T], H) :- maiorlista(T, A), H>=A.
maiorlista([H|T], A) :- maiorlista(T, A), H<A.

% ---------------------------------------------------------------------------------------
% ix) Extensao do predicado menordois : Valor, Valor, Resultado -> {V, F}

menordois(X, Y, X) :- X=<Y.
menordois(X, Y, Y) :- X>Y.

% ---------------------------------------------------------------------------------------
% x) Extensao do predicado menortres : Valor, Valor, Valor, Resultado -> {V, F}

menortres(X, Y, Z, X) :- X =< Y, X =< Z.
menortres(X, Y, Z, Y) :- Y =< X, Y =< Z.
menortres(X, Y, Z, Z) :- Z =< X, Z =< Y.

% ---------------------------------------------------------------------------------------
% xi) Extensao do predicado menorlista : Lista, Resultado -> {V, F}

menorlista([], -1).
menorlista([H], H).
menorlista([H|T], H) :- menorlista(T, A), H=<A.
menorlista([H|T], A) :- menorlista(T, A), H>A.

% ---------------------------------------------------------------------------------------
% xii) Extensao do predicado media : Lista, Media, Usados -> {V, F}

total([], 0).
total([H|T], A) :- total(T, X), A is X+H.

media([], 0, 0).
media([H], H, 1).
media([H|T], M, X) :- total([H|T], A), M is A/X.

% ---------------------------------------------------------------------------------------
% xiii) Extensao do predicado crescente : Lista, Lista -> {V, F}.

crescente([], []).
crescente([H|T], []) :- crescente(T, [H]).
crescente([H|T], [A|B]) :- crescente(T, [A,B|H]).

% ---------------------------------------------------------------------------------------
% xiv) Extensao do predicado decrescente : Lista, Lista -> {V, F}.

decrescente([], []).

% ---------------------------------------------------------------------------------------
% xv) Extensao do predicado quantosvazios : Lista, Valor -> {V, F}.

quantosvazios([], 0).
quantosvazios([[]|T], X) :- quantosvazios(T, A), X is A+1.
quantosvazios([H|T], X) :- quantosvazios(T, X).

% ---------------------------------------------------------------------------------------
% xvi) Extensao do predicado oposto : 