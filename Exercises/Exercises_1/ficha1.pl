%----------------------------------------------------------------------------------------
:- dynamic filho/2. % por forma a podermos realizar um assert na base de conhecimento
%----------------------------------------------------------------------------------------

%----------------------------------------------------------------------------------------
% Extensao do predicado filho: Filho, Pai -> {V,F}

filho(joao, jose).                                              %questao 1
filho(jose, manuel).                                            %questao 2
filho(carlos, jose).                                            %questao 3

%----------------------------------------------------------------------------------------
% Extensao do predicado pai: Pai, Filho -> {V, F}

pai(paulo, filipe).                                             %questao 4
pai(paulo, maria).                                              %questao 5
pai(P, F) :- filho(F, P).                                       %questao 12

%----------------------------------------------------------------------------------------
% Extensao do predicado avo: Avo, Neto -> {V, F}

avo(antonio, nadia).                                            %questao 6
avo(A, N) :- pai(A, X), pai(X, N).                              %questao 13

%----------------------------------------------------------------------------------------
% Extensao do predicado neto: Neto, Avo -> {V, F}

neto(nuno, ana).                                                %questao 7
neto(N, A) :- avo(A, N).                                        %questao 14

%----------------------------------------------------------------------------------------
% Extensao do predicado sexo: Nome, Sexo -> {V, F}

sexo(joao, masculino).                                          %questao 8
sexo(jose, masculino).                                          %questao 9
sexo(maria, feminino).                                          %questao 10
sexo(joana, feminino).                                          %questao 11

%----------------------------------------------------------------------------------------
% Extensao do predicado descendente: Descendente, Ascendente -> {V, F}

descendente(X, Y) :- filho(X, Y).                               %questao 15
descendente(X, Y) :- pai(Y, X).
descendente(X, Y) :- filho(X, P), descendente(P, Y).
descendente(X, Y) :- pai(Y, P), descendente(X, P).

%----------------------------------------------------------------------------------------
% Extensao do predicado graudesc: Descendente, Ascendente, Grau -> {V, F}

graudesc(X, Y, 1) :- filho(X, Y).                               %questao 16
graudesc(X, Y, 2) :- avo(Y, X).
graudesc(X, Y, G) :- filho(X, P), graudesc(P, Y, N), G is N+1.
graudesc(X, Y, G) :- pai(Y, P), graudesc(X, P, N), G is N+1.

%----------------------------------------------------------------------------------------
% Extensao do predicado avodesc: Avo, Neto -> {V, F}

avodesc(A, N) :- graudesc(N, A, 2).                             %questao 17

%----------------------------------------------------------------------------------------
% Extensao do predicado bisavo: Bisavo, Bisneto -> {V, F}

bisavo(X, Y) :- graudesc(Y, X, 3).                              %questao 18

%----------------------------------------------------------------------------------------
% Extensao do predicado trisavo: Trisavo, Trisneto -> {V, F}

trisavo(X, Y) :- graudesc(Y, X, 4).                             %questao 19

%----------------------------------------------------------------------------------------
% Extensao do predicado tetrasavo: Tetrasavo, Tetrasneto -> {V, F}

tetrasavo(X, Y) :- graudesc(Y, X, 5).                           %questao 20