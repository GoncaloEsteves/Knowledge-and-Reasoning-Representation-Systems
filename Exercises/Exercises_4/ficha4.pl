%----------------------------------------------------------------------
% i) Extensao do predicado pares : Valor -> {V, F}.

pares(0).
pares(-1) :- !, fail.
pares(X) :- X > 0, A is X-2, pares(A).
pares(X) :- X < 0, A is X+2, pares(A).

%----------------------------------------------------------------------
% ii) Extensao do predicado impares : Valor -> {V, F}.

impares(1).
impares(-1).
impares(0) :- !, fail.
impares(X) :- X > 0, A is X-2, impares(A).
impares(X) :- X < 0, A is X+2, impares(A). 

%----------------------------------------------------------------------
% iii) Extensao do predicado natural : Valor -> {V, F}.

natural(1).
natural(X) :- X > 0, A is X-1, natural(A).

%----------------------------------------------------------------------
% iv) Extensao do predicado inteiro : Valor -> {V, F}.

inteiro(0).
inteiro(X) :- X > 0, X < 1, !, fail.
inteiro(X) :- X > 0, A is X-1, inteiro(A).
inteiro(X) :- X < 0, A is X+1, inteiro(A).

%----------------------------------------------------------------------
% v) Extensao do predicado divisores : Valor, Lista -> {V, F}.

divide(0, _).
divide(A, B) :- A > 0, X is A-B, divide(X, B).

divisores(0, []).
divisores(1, [1]).
divisores(X, [H|T]) :- divide(X, H), divisores(X, T).

%----------------------------------------------------------------------
% vi) Extensao do predicado primo : Valor -> {V, F}.

naodivisivel(0, _) :- !, fail.
naodivisivel(X, _) :- X < 0.
naodivisivel(X, M) :- Y is X-M, naodivisivel(Y, M).

primoaux(_, 1).
primoaux(X, A) :- naodivisivel(X, A), B is A-1, primoaux(X, B).

primo(0).
primo(1).
primo(X) :- A is X-1, primoaux(X, A).

%----------------------------------------------------------------------
% vii) Extensao do predicado mdc : Valor, Valor, Valor -> {V, F}.

mdc(X, X, X).
mdc(X, Y, D) :- X >= Y, Z is X-Y, mdc(Z, Y, D).
mdc(X, Y, D) :- X < Y, Z is Y-X, mdc(X, Z, D).

%----------------------------------------------------------------------
% viii) Extensao do predicado mmc : Valor, Valor, Valor -> {V, F}.

divisivel(0, _).
divisivel(X, _) :- X < 0, !, fail.
divisivel(X, M) :- Y is X-M, divisivel(Y, M).

mmcaux(X, Y, M, Z) :- X =< Y, divisivel(M, X), M = Z.
mmcaux(X, Y, M, Z) :- X > Y, divisivel(M, Y), M = Z.
mmcaux(X, Y, M, Z) :- X =< Y, A is M+Y, mmcaux(X, Y, A, Z).
mmcaux(X, Y, M, Z) :- X > Y, A is M+X, mmcaux(X, Y, A, Z).


mmc(X, Y, Z) :- X >= Y, mmcaux(X, Y, X, Z).
mmc(X, Y, Z) :- X < Y, mmcaux(X, Y, Y, Z).

%----------------------------------------------------------------------
% ix) Extensao do predicado fib : Indice, Valor -> {V, F}.

fib(0, 0).
fib(1, 1).
fib(N, X) :- N > 1, N1 is N-1, N2 is N-2,
			 fib(N1, A), fib(N2, B), X is A+B.