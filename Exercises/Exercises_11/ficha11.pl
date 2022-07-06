%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: Declaracoes iniciais

:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- set_prolog_flag( unknown,fail ).

% estado inicial
inicial(jarros(0, 0)).

% estados finais
final(jarros(4, _)).
final(jarros(_, 4)).

% transições possíveis transicao: Ei x Op x Ef

transicao(jarros(V1, V2), encher(1), jarros(8, V2)):- V1 < 8.
transicao(jarros(V1, V2), encher(2), jarros(V1, 5)):- V2 < 5.

transicao(jarros(V1, V2), encher(1, 2), jarros(NV1, NV2)):- 
	V1 > 0,
	NV1 is max(V1 - 5 + V2, 0), 
	NV1 < V1, 
	NV2 is V2 + V1 - NV1.
transicao(jarros(V1, V2), encher(2, 1), jarros(NV1, NV2)):- 
	V2 > 0,
	NV2 is max(V2 - 8 + V1, 0), 
	NV2 < V2, 
	NV1 is V1 + V2 - NV2.

transicao(jarros(V1, V2), vazio(1), jarros(0, V2)):- V1 > 0.
transicao(jarros(V1, V2), vazio(2), jarros(V1, 0)):- V2 > 0.

%-------------------------------------------------------
resolvedf(Solucao) :- inicial(InicialEstado), resolvedf(InicialEstado, [InicialEstado], Solucao).

resolvedf(Estado, _, []) :- final(Estado), !.
resolvedf(Estado, Historico, [Move|Solucao]) :- transicao(Estado, Move, Estado1), nao(membro(Estado1, Historico)), resolvedf(Estado1, [Estado1|Historico], Solucao).

%----------------
todos(L) :- findall((S, C), (resolvedf(S), length(S, C)), L).

melhor(S, Custo) :- findall((S, C), (resolvedf(S), length(S, C)), L), minimo(L, (S, Custo)).

escrever([]).
escrever([X|L]) :- write(X), nl, escrever(L).

minimo([(P, X)], (P, X)).
minimo([(Px, X)|L], (Py, Y)) :- minimo(L, (Py, Y)), X > Y.
minimo([(Px, X)|L], (Px, X)) :- minimo(L, (Py, Y)), X =< Y.