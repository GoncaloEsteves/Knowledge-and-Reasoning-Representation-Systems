%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SIST. REPR. CONHECIMENTO E RACIOCINIO - MiEI/3

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Programacao em logica 
% Grafos (Ficha 9)

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: Declaracoes iniciais

:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- set_prolog_flag( unknown,fail ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -

g( grafo([madrid, cordoba, sevilla, jaen, granada, huelva, cadiz],
  [aresta(huelva, sevilla, a49, 94),
   aresta(sevilla, cadiz,ap4, 125),
   aresta(sevilla, granada, a92, 125),
   aresta(granada, jaen,a44, 97),
   aresta(sevilla, cordoba, a4, 138),
   aresta(jaen,madrid, a4, 335),
   aresta(cordoba, madrid, a4, 400)]
 )).

%--------------------------------- - - - - - - - - - -  -  -  -  -   - 
% Extensao do predicado adjacente : No, No, Grafo -> {V, F, D}

adjacente(X, Y, E, Km, grafo(_,Es)) :- member(aresta(X, Y, E, Km), Es).
adjacente(X, Y, E, Km, grafo(_,Es)) :- member(aresta(Y, X, E, Km), Es).

%--------------------------------- - - - - - - - - - -  -  -  -  -   - 
% Extensao do predicado caminho : Grafo, No, No, Caminho, Quilometros, Estradas -> {V, F, D}

caminhoAux(_, X, [X|P], [X|P], Km, Km, Es, Es).
caminhoAux(G, X, [Y|P], C, Kmaux, Km, Esaux, Es) :- adjacente(A, Y, E, K, G), \+ memberchk(A, [Y|P]), Km1 is Kmaux+K, append([E], Esaux, Es1), caminhoAux(G, X, [A, Y|P], C, Km1, Km, Es1, Es).

caminho(G, X, Y, C, Km, Es) :- caminhoAux(G, X, [Y], C, 0, Km, [], Es).

%--------------------------------- - - - - - - - - - -  -  -  -  -   - 
% Extensao do predicado ciclo : Grafo, No, Caminho, Quilometros, Estradas -> {V, F, D}

ciclo(G, A, C, Km, Es) :- adjacente(B, A, E, K, G), caminho(G, A, B, C1, Km1, Es1), length(C1, L), L > 2, append(C1, [A], C), Km is Km1+K, append(Es1, [E], Es).