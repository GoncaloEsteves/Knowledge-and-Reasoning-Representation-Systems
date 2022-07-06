%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Programacao em logica estendida
% Representacao de conhecimento imperfeito

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: Declaracoes iniciais

:- set_prolog_flag(discontiguous_warnings, off).
:- set_prolog_flag(single_var_warnings, off).
:- set_prolog_flag(unknown, fail).

%--------------------------------- - - - - - - - - - -  -  -  -  -  -
% SICStus PROLOG: definicoes iniciais

:- op(900, xfy, '::').
:- dynamic jogo/3.
:- dynamic '-'/1.

%--------------------------------- - - - - - - - - - -  -  questão i

jogo(1, aa, 500).

%--------------------------------- - - - - - - - - - -  -  questão ii

jogo(2, bb, xpto0123).
excecao(jogo(Jogo, Arbitro, Ajudas)) :- jogo(Jogo, Arbitro, xpto0123).

%--------------------------------- - - - - - - - - - -  -  questão iii

excecao(jogo(3, cc, 500)).
excecao(jogo(3, cc, 2500)).

%--------------------------------- - - - - - - - - - -  -  questão iv

excecao(jogo(4, dd, V)) :- V >= 250, V =< 750.

%--------------------------------- - - - - - - - - - -  -  questão v

jogo(5, ee, xpto0123).

%--------------------------------- - - - - - - - - - -  -  questão vi

excecao(jogo(6, ff, V)) :- V == 250; V > 5000.

%--------------------------------- - - - - - - - - - -  -  questão vii

-jogo(7, gg, 2500).
-jogo(Id, Nome, Valor) :- nao(jogo(Id, Nome, Valor)), nao(excecao(jogo(Id, Nome, Valor))).
jogo(7, gg, xpto0123).

%--------------------------------- - - - - - - - - - -  -  questão viii

cerca(X, Sup, Inf) :- Sup is X * 1.25, Inf is X * 0.75.
excecao(jogo(8, hh, V)) :- cerca(1000, Sup, Inf), V =< Sup, V >= Inf.

%--------------------------------- - - - - - - - - - -  -  questão ix

proximoDe(X, Sup, Inf) :- Sup is X * 1.125, Inf is X * 0.875.
excecao(jogo(9, ii, V)) :- proximoDe(3000, Sup, Inf), V =< Sup, V >= Inf.

%--------------------------------- - - - - - - - - - -  -  questão x

solucoes(A, B, C) :- findall(A, B, C).
comprimento(S, N) :- length(S, N).
+jogo(Id, Nome, Valor) :: (solucoes(Id, (jogo(Id, Nome, Valor)), S), comprimento(S, N), N == 1).

%--------------------------------- - - - - - - - - - -  -  questão xi

+jogo(Id, Nome, Valor) :: (solucoes(Nome, (jogo(Id, Nome, Valor)), S), comprimento(S, N), N =< 3).

%--------------------------------- - - - - - - - - - -  -  questão xii



% Extensao do meta predicado si: questao, resposta -> {V, F, D}

si(Questao, verdadeiro) :- Questao.
si(Questao, falso) :- -Questao.
si(Questao, desconhecido) :- nao(Questao), nao(-Questao).

% Extensao do meta predicado nao: Questao -> {V, F}

nao(Questao) :- Questao, !, fail.
nao(Questao).