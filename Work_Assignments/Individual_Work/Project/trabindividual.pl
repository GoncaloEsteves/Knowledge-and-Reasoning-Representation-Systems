% Trabalho Individual

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: Declaracoes iniciais

:- set_prolog_flag(discontiguous_warnings, off).
:- set_prolog_flag(single_var_warnings, off).
:- set_prolog_flag(unknown, fail).



%------------------- IMPORTAR DADOS PARA A BASE DE CONHECIMENTO - - - - - - - - - -  -  -  -  -  -

%---------------------------------- - - - - - - - - - -  -  -  -  -   -
% Leitura dos ficheiros com os dados das cidades, ligacoes, monumentos e turismo
% e consequente inserção dos mesmos na base de conhecimento
% Extensão do predicado lerInfo -> {V,F}

lerInfo :- open('D:/SRCR/cidades.pl', read, Str1),
    	   lerFicheiro(Str1, Lines1), close(Str1), insereInfo(Lines1),
    	   open('D:/SRCR/ligacoes.pl', read, Str2),
    	   lerFicheiro(Str2, Lines2), close(Str2), insereInfo(Lines2),
    	   open('D:/SRCR/monumentos.pl', read, Str3),
    	   lerFicheiro(Str3, Lines3), close(Str3), insereInfo(Lines3),
    	   open('D:/SRCR/turismo.pl', read, Str4),
    	   lerFicheiro(Str4, Lines4), close(Str4), insereInfo(Lines4).

lerFicheiro(Stream, []) :- at_end_of_stream(Stream).
lerFicheiro(Stream, [X|L]) :- \+ at_end_of_stream(Stream), read(Stream, X), lerFicheiro(Stream, L). 

%---------------------------------- - - - - - - - - - -  -  -  -  -   -
% Insere informação na base de conhecimento
% Extensão do predicado insereInfo: Lista -> {V,F}
insereInfo([]).
insereInfo([X|T]) :- insercao(X), insereInfo(T).



%------------------- PREDICADOS DE INTERAÇÃO COM O UTILIZADOR   -  -  -  -  -

% Determinar se para um dado id, a cidade fornecida está correta
% Extensao do predicado idCidade: ID, Cidade -> {V, F}

idCidade(Id, C) :- cidade(Id, C, _, _, _, _), !.

% Determinar se uma cidade é capital do país
% Extensao do predicado capital: Cidade -> {V, F}

capital(C) :- cidade(_, C, _, _, _, primary), !.

% Lista com todas as cidades com poder administrativo
% Extensao do predicado cidadesAdministradoras -> {V, F}

cidadesAdministradoras :- solucoes(Id, cidade(Id, _, _, _, _, admin), C), imprimeCidades(C), !.

% Lista com todas as cidades administradas por uma dada cidade
% Extensao do predicado cidadesAdministradas: Administrador -> {V, F}

cidadesAdministradas(A) :- solucoes(Id, cidade(Id, _, _, _, A, minor), C), imprimeCidades(C).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Lista de todos os monumentos de uma dada cidade
% Extensao do predicado monumentosCidade: Cidade, Monumentos -> {V, F}

monumentosCidade(C, M) :- idCidade(Id, C), solucoes(Mon, monumento(Mon, Id), M).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Lista de todas as cidades características de um dado tipo de turismo
% Extensao do predicado cidadesPorTurismo: Tipo de Turismo -> {V, F}

cidadesPorTurismo(T) :- solucoes(Cid, turismo(T, Cid), C), imprimeCidades(C).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Lista de todas as cidades a que uma dada cidade tem ligação direta
% Extensao do predicado ligacoesCidade: Cidade -> {V, F}

ligacoesCidade(C) :- idCidade(Id, C),
					 solucoes(Cid1, ligacao(Id, Cid1, _), C1),
					 solucoes(Cid2, ligacao(Cid2, Id, _), C2),
					 append(C1, C2, L),
					 imprimeCidades(L).



%-------------------        QUERIES        - - - - - - - - - -  -  -  -  -  -

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Dadas duas cidades, verifica se há uma ligação direta entre elas
% Extensao do predicado adjacente : Origem, Fim, Quilómetros-> {V, F, D}

adjacente(X, Y, Km) :- ligacao(X, Y, Km).
adjacente(X, Y, Km) :- ligacao(Y, X, Km).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Calculo do caminho entre duas cidades,
% recorrendo ao Algoritmo Depth First
% Extensao do predicado caminho: Origem, Fim, Quilómetros -> {V, F}

caminhoAux(X, X, [], _, 0).
caminhoAux(X, Y, [A|C], V, Km) :- X \= Y, adjacente(X, A, Km1), \+ memberchk(A, V), 
								  caminhoAux(A, Y, C, [X|V], Km2), Km is Km1+Km2.

caminho(X, Y, Km) :- idCidade(IdX, X), idCidade(IdY, Y),
					 caminhoAux(IdX, IdY, C, [], Km),
					 imprimeCidades([IdX|C]).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Calculo do caminho entre duas cidades, percorrendo apenas cidades com uma determinada caracteristica,
% recorrendo ao Algoritmo Depth First
% Extensao do predicado caminhoComCaracteristica: Origem, Fim, Caracteristica, Quilómetros -> {V, F}

caminhoCCAux(X, X, Car, [], _, 0).
caminhoCCAux(X, Y, Car, [A|C], V, Km) :- X \= Y, adjacente(X, A, Km1), turismo(Car, A), \+ memberchk(A, V),
									     caminhoCCAux(A, Y, Car, C, [X|V], Km2), Km is Km1+Km2.

caminhoComCaracteristica(X, Y, Car, Km) :- idCidade(IdX, X), idCidade(IdY, Y),
									       caminhoCCAux(IdX, IdY, Car, Cam, [], Km),
					 					   imprimeCidades([IdX|Cam]).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Calculo do caminho entre duas cidades, percorrendo apenas cidades sem as caracteristicas indicadas,
% recorrendo ao Algoritmo Depth First
% Extensao do predicado caminhoSemCaracteristica: Origem, Fim, Caracteristicas, Quilómetros -> {V, F}

caminhoSCAux(X, X, Car, [], _, 0).
caminhoSCAux(X, Y, Car, [A|C], V, Km) :- X \= Y, adjacente(X, A, Km1), \+ memberchk(A, V), 
										 ((turismo(CarAux, A), \+ memberchk(CarAux, Car)); (\+ turismo(_, A))),
									  	 caminhoSCAux(A, Y, Car, C, [X|V], Km2), Km is Km1+Km2.

caminhoSemCaracteristica(X, Y, Car, Km) :- idCidade(IdX, X), idCidade(IdY, Y),
									       caminhoSCAux(IdX, IdY, Car, Cam, [], Km),
					 					   imprimeCidades([IdX|Cam]).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Determinar qual a cidade com o maior número de ligações, dentro de um determinado percurso
% Extensao do predicado maisLigacoes: Caminho, Cidade, Nº de Ligaçoes -> {V, F}

numeroLigacoes(C, N) :- solucoes(A1, ligacao(A1, C, _), L1), length(L1, N1),
					    solucoes(A2, ligacao(C, A2, _), L2), length(L2, N2),
					    N is N1+N2.

maisLigacoes([Id], C, N) :- idCidade(Id, C), numeroLigacoes(Id, N).
maisLigacoes([Id|T], X, N) :- maisLigacoes(T, X, N),
							  numeroLigacoes(Id, N2),
							  N >= N2.
maisLigacoes([Id|T], C, N2) :- maisLigacoes(T, X, N),
							   numeroLigacoes(Id, N2),
							   idCidade(Id, C),
							   N < N2.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Calculo do menor caminho entre duas cidades (menor número de cidades percorridas),
% recorrendo ao Algoritmo Breadth First
% Extensao do predicado menorCaminhoDF: Origem, Fim -> {V, F}

menorCaminho(X, Y) :- idCidade(IdX, X), idCidade(IdY, Y),
					  algBreadthFirst(IdX, IdY, [[IdX]], L),
					  inverso(L, C),
					  imprimeCidades(C).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Calculo do caminho mais curto entre duas cidades (menor número de quilometros percorridos),
% recorrendo ao Algoritmo A Estrela
% Extensao do predicado caminhoMaisRapido: Origem, Fim, Quilómetros -> {V, F}

caminhoMaisRapido(X, Y, Km) :- idCidade(IdX, X), idCidade(IdY, Y),
							   distanciaCidades(IdX, IdY, R),
        					   algAEstrela(IdX, IdY, [[IdX]/0/R], L/Km/_),
        					   inverso(L, C),
        					   imprimeCidades(C).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Calculo do caminho entre duas cidades, percorrendo apenas cidades minor
% Extensao do predicado caminhoPorMinor: Origem, Fim, Quilómetros -> {V, F}

caminhoPMAux(X, X, [], _, 0).
caminhoPMAux(X, Y, [A|C], V, Km) :- X \= Y, adjacente(X, A, Km1), cidade(A, _, _, _, _, minor), \+ memberchk(A, V),
									caminhoPMAux(A, Y, C, [X|V], Km2), Km is Km1+Km2.

caminhoPorMinor(X, Y, Km) :- idCidade(IdX, X), idCidade(IdY, Y),
							 caminhoPMAux(IdX, IdY, C, [], Km),
						 	 imprimeCidades([IdX|C]).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Calculo do caminho entre duas cidades, passando por uma série de cidades definidas
% Extensao do predicado caminhoPorCidades: Origem, Fim, Cidades, Quilómetros -> {V, F}

caminhoPorCidadesAux(X, Y, [H], C, Km) :- idCidade(IdX, X), idCidade(IdY, Y), idCidade(IdH, H),
							   			  distanciaCidades(IdX, IdH, R1), distanciaCidades(IdH, IdY, R2),
							   			  algAEstrela(IdX, IdH, [[IdX]/0/R1], C1/Km1/_), algAEstrela(IdH, IdY, [[IdH]/0/R2], C2/Km2/_),
										  append(C2, C1, C), Km is Km1+Km2.
caminhoPorCidadesAux(X, Y, [H|T], C, Km) :- idCidade(IdX, X), idCidade(IdY, Y), idCidade(IdH, H),
							   		  		distanciaCidades(IdX, IdH, R1),
									  		algAEstrela(IdX, IdH, [[IdX]/0/R1], C1/Km1/_), caminhoPorCidadesAux(H, Y, T, C2, Km2),
									 		append(C2, C1, C), Km is Km1+Km2.

caminhoPorCidades(X, Y, [H|T], Km) :- caminhoPorCidadesAux(X, Y, [H|T], L, Km), inverso(L, C), imprimeCidades(C).



%------------------- PREDICADOS AUXILIARES - - - - - - - - - -  -  -  -  -  -

%---------------------------------- - - - - - - - - - -  -  -  -  -   -
% Algoritmo A Estrela
% Extensão do predicado algAEstrela: Origem, Fim, Visitados, Caminho -> {V,F}

adjacenteAux(X, [C|Cam]/Dist/_, [PC, C|Cam]/NDist/Est) :- adjacente(C, PC, PDist), \+ member(PC, Cam),
    													  NDist is Dist + PDist,
    													  distanciaCidades(PC, X, Est).

melhor([Cam], Cam) :- !.
melhor([Cam1/Dist1/Est1,_/Dist2/Est2|Cams], MCam) :- Dist1 + Est1 =< Dist2 + Est2, !,
    												 melhor([Cam1/Dist1/Est1|Cams], MCam).
melhor([_|Cams], MCam) :- melhor(Cams, MCam).

extendeE(X, Cam, CamsAux) :- findall(NCam, adjacenteAux(X, Cam, NCam), CamsAux).

algAEstrela(X, Y, Cams, Cam) :- melhor(Cams, Cam),
        						Cam = [C|_]/_/_,
        						C == Y.
algAEstrela(X, Y, Cams, S) :- melhor(Cams, M),
        					  extendeE(Y, M, CamsAux),
        					  algAEstrela(X, Y, CamsAux, S).

%---------------------------------- - - - - - - - - - -  -  -  -  -   -
% Algoritmo Breadth First
% Extensão do predicado algBreadthFirst: Origem, Fim, Extendidos, Caminho -> {V,F}

algBreadthFirst(X, Y, [[Y|C]|_], [Y|C]).
algBreadthFirst(X, Y, [Cam|Cams], C) :- extende(Cam, NCams),
										append(Cams, NCams, Aux),
										algBreadthFirst(X, Y, Aux, C).

extende([A|Cam], NCams) :- solucoes([NA, A|Cam], 
									(adjacente(A, NA, K), \+ memberchk(NA, [A|Cam])),
									NCams), !.
extende(Cam, []).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensão do predicado solucoes: Termo, Questão, Resultado -> {V,F}

solucoes(X, Y, Z) :- findall(X, Y, Z).

%---------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensão do predicado insercao: Termo -> {V,F}

insercao(Termo) :- assert(Termo).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensão do predicado inverso: Lista, Resultado -> {V,F}

inverso(L, N):- inversoAux(L, [], N).

inversoAux([], L, L).
inversoAux([X|L], Aux, N) :- inversoAux(L, [X|Aux], N).

%---------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensão do predicado distanciaCidades: Ponto1, Ponto2, Resultado -> {V,F}
distanciaCidades(X, Y, RR) :- cidade(X, _, LatX, LonX, _, _),
    						  cidade(Y, _, LatY, LonY, _, _),  
    						  R is sqrt((LatX-LatY)^2 + (LonX-LonY)^2),
    						  RR is R*111.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensão do predicado imprimeCidades: Cidades -> {V,F}

imprimeCidades([Id]) :- idCidade(Id, C), write(C), nl.
imprimeCidades([Id|T]) :- idCidade(Id, C), write(C), nl, imprimeCidades(T).