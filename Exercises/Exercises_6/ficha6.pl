% SICStus PROLOG: Declaracoes iniciais
 
:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- set_prolog_flag( unknown,fail ).
 
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: definicoes iniciais
 
:- dynamic '-'/1.
:- dynamic mamifero/1.
:- dynamic morcego/1.
 
:- op( 1100,xfy,'??' ).
 
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% i) Extensao do predicado voa: Ave -> {V, F}.

voa(X) :- ave(X), nao(excecao(voa(X))).
voa(X) :- excecao(-voa(X)).

%---------------------------------------------------------------------
% ii) 

-voa(X) :- mamifero(X), nao(excecao(-voa(X))).
-voa(X) :- excecao(voa(X)).

%---------------------------------------------------------------------
% iii)

-voa(tweety).

%---------------------------------------------------------------------
% iv)

ave(pitigui).

%---------------------------------------------------------------------
% v)

ave(X) :- canario(X).

%---------------------------------------------------------------------
% vi)

ave(X) :- piriquito(X).

%---------------------------------------------------------------------
% vii)

canario(piupiu).

%---------------------------------------------------------------------
% viii)

mamifero(silvestre).

%---------------------------------------------------------------------
% ix)

mamifero(X) :- cao(X).

%---------------------------------------------------------------------
% x)

mamifero(X) :- gato(X).

%---------------------------------------------------------------------
% xi)

cao(bobby).

%---------------------------------------------------------------------
% xii)

ave(X) :- avestruz(X).
excecao(voa(X)) :- avestruz(X).

%---------------------------------------------------------------------
% xiii)

ave(X) :- pinguim(X).
excecao(voa(X)) :- pinguim(X).

%---------------------------------------------------------------------
% xiv)

avestruz(truz).

%---------------------------------------------------------------------
% xv)

pinguim(pingu).

%---------------------------------------------------------------------
% xvi)

mamifero(X) :- morcego(X).
excecao(-voa(X)) :- morcego(X).

%---------------------------------------------------------------------
% xvii)

morcego(batemene).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do meta-predicado si: Questao,Resposta -> {V,F}
%                            Resposta = { verdadeiro,falso,desconhecido }
 
si(Questao,verdadeiro) :- Questao.
si(Questao,falso) :- -Questao.
si(Questao,desconhecido) :- nao(Questao), nao(-Questao).
 
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do meta-predicado nao: Questao -> {V,F}
 
nao(Questao) :- Questao, !, fail.
nao(Questao).