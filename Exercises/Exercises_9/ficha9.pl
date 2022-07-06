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

g(grafo([a,b,c,d,e,f,g], [aresta(a,b),aresta(c,d),aresta(c,f),aresta(d,f),aresta(f,g)])).	

g1(grafo([a,b,c,d,e,f,g], [aresta(a,b),aresta(c,d),aresta(c,f),aresta(d,f),aresta(f,g), aresta(f,e), aresta(e,d)])).	


%--------------------------------- - - - - - - - - - -  -  -  -  -   - 
% Extensao do predicado adjacente : No, No, Grafo -> {V, F, D}

adjacente(X,Y,grafo(_,Es)) :- member(aresta(X,Y),Es).
adjacente(X,Y,grafo(_,Es)) :- member(aresta(Y,X),Es).

%--------------------------------- - - - - - - - - - -  -  -  -  -   - 
% Extensao do predicado caminho : Grafo, No, No, Caminho -> {V, F, D}

caminhoAux(_, X, [X|P], [X|P]).
caminhoAux(G, X, [Y|P], C) :- adjacente(A, Y, G), \+ memberchk(A, [Y|P]), caminhoAux(G, X, [A, Y|P], C).

caminho(G, X, Y, C) :- caminhoAux(G, X, [Y], C).

%--------------------------------- - - - - - - - - - -  -  -  -  -   - 
% Extensao do predicado ciclo : Grafo, No, Caminho -> {V, F, D}

ciclo(G, A, C) :- adjacente(B, A, G), caminho(G, A, B, C1), length(C1, L), L > 2, append(C1, [A], C).