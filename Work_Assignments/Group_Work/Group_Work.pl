% Trabalho Prático 1

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: Declaracoes iniciais

:- set_prolog_flag(discontiguous_warnings, off).
:- set_prolog_flag(single_var_warnings, off).
:- set_prolog_flag(unknown, fail).

%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% SICStus PROLOG: definicoes iniciais

:- op(900, xfy, '::').
:- dynamic '-'/1.
:- dynamic adjudicante/4.
:- dynamic adjudicataria/4.
:- dynamic contrato/12.
:- dynamic excecaoIncerta/1.
:- dynamic excecaoImprecisa/1.
:- dynamic excecaoImprecisaIntervalo/3.
:- dynamic excecaoInterdita/1.
:- dynamic nuloInterdito/1.
:- dynamic (::)/2.

%-------------------- CONHECIMENTO POSITIVO - - - - - -  -  -  -  -  -

%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Extensão do predicado adjudicante: #IdAd, Nome, NIF, Morada -> {V, F, D}
adjudicante(1, municipio_altodebasto, 705330336, portugal_braga_altodebasto).
adjudicante(2, municipio_guarda, 700000000, portugal_guarda).
adjudicante(3, municipio_vilaverde, 700000001, portugal_braga_vilaverde).

%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Extensão do predicado adjudicataria: #IdAd, Nome, NIF, Morada -> {V, F, D}
adjudicataria(1, xxx_associados_sociedadedeadvogados_sp_rl, 702675112, portugal).
adjudicataria(2, mm_lda, 711111111, portugal).
adjudicataria(3, rollido_companhia, 711111112, portugal).

%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Extensão do predicado contrato: #IdAd, #IdAda, #IdC, TipoDeContrato, TipoDeProcedimento, Descrição, Valor, Prazo, Local, Dia, Mes, Ano -> {V, F, D}
contrato(1, 1, 1, aquisicao_de_servicos, consulta_previa, assessoriajuridica, 72000, 547, altodebasto, 01, 01, 2010).
contrato(1, 2, 2, locacao_de_bens_moveis, ajuste_direto, assessoriajuridica, 2000, 240, altodebasto, 02, 02, 2000).
contrato(2, 3, 3, contrato_de_aquisicao, ajuste_direto, assessoriajuridica, 4000, 360, braga, 03, 03, 2010).

%------------------- CONHECIMENTO NEGATIVO - - - - - - - - - -  -  -  -  -  -

%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Extensão da negação forte do predicado adjudicante
-adjudicante(Id, Nome, NIF, M) :- 
		nao(adjudicante(Id, Nome, NIF, M)),
		nao(excecaoIncerta(adjudicante(Id, Nome, NIF, M))),
		nao(excecaoImprecisa(adjudicante(Id, Nome, NIF, M))),
		nao(excecaoImprecisaIntervalo(adjudicante(Id, Nome, NIF, M),_,_)),
		nao(excecaoInterdita(adjudicante(Id, Nome, NIF, M))).

%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Extensão da negação forte do predicado adjudicataria
-adjudicataria(Id, Nome, NIF, M) :- 
		nao(adjudicataria(Id, Nome, NIF, M)),
		nao(excecaoIncerta(adjudicataria(Id, Nome, NIF, M))),
		nao(excecaoImprecisa(adjudicataria(Id, Nome, NIF, M))),
		nao(excecaoImprecisaIntervalo(adjudicataria(Id, Nome, NIF,M),_,_)),
		nao(excecaoInterdita(adjudicataria(Id, Nome, NIF, M))).

%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Extensão da negação forte do predicado contrato
-contrato(IdAd, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A) :- 
		nao(contrato(IdAd, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A)),
		nao(excecaoIncerta(contrato(IdAd, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A))),
		nao(excecaoImprecisa(contrato(IdAd, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A))),
		nao(excecaoImprecisa(contrato(IdAd, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A)), _, _),
		nao(excecaoInterdita(contrato(IdAd, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A))).

%------------------- INVARIANTES QUE O "DOCUMENTO DE APOIO" INDICA - - - - - - - - - -  -  -  -  -  -

%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Só são possíveis 3 tipos de procedimentos nos contratos
+contrato(_, _, _, _, TP, _, _, _, _, _, _, _) :: 
		(member(TP, [ajuste_direto, consulta_previa, concurso_publico])).	

%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Condições obrigatórias do contrato por ajuste direto nos contratos
+contrato(_, _, _, TC, TP, _, V, P, _, _, _, _) :: 
		((member(TP, [consulta_previa, concurso_publico]));
		(TP == ajuste_direto,
				member(TC, [contrato_de_aquisicao, locacao_de_bens_moveis, aquisicao_de_servicos]),
				V =< 5000, 
				P =< 365)).
%->--------------------------------- - - - - - - - - - -  -  -  -  -  -
% Regra dos 3 anos válida para todos os contratos
+contrato(_, IdAa, _, TC1, TP1, _, _, _, _, _, _, A1) ::
		((solucoes(V, (contrato(_, IdAda, _, _, TP, _, V, _, _, _, _, A), 
				TP == TP1, (A1-2) =< A, A1 >= A), L1),
		solucoes(V, (contrato(_, IdAda, _, TC,_, _, V, _, _, _, _, A), 
				TC == TC1, (A1-2) =< A, A1 >= A), L2),
		apagaUltimo(L1, L11),
		apagaUltimo(L2, L22),
		concatenar(L11, L22, L3),
		soma(L3, R),
		R < 75000)).

%------------------- INVARIANTES - - - - - - - - - -  -  -  -  -  -

%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Não permite que haja IDs iguais nos ajudicantes
+adjudicante(Id, _, _, _) ::  (solucoes((Id),(adjudicante(Id, Nome, NIF, M)),S),
							  comprimento(S,N), 
				  			  N =< 1).

%-->-------------------------------- - - - - - - - - - -  -  -  -  -  -
% Não permite que haja IDs iguais nos adjudicatárias
+adjudicataria(Id, _, _, _) :: (solucoes((Id),(adjudicataria(Id, Nome, NIF, M)),S),
                  		   	    comprimento(S,N), 
				  			  	N =< 1).	

%-->-------------------------------- - - - - - - - - - -  -  -  -  -  -
% Não permite que haja IDs de contrato iguais nos contratos
+contrato(_, _, IdC, _, _, _, _, _, _, _, _, _) :: (solucoes((IdC),(contrato(IdAd, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A)),S),
                  		   	         		  comprimento(S,N), 
				  			  	    		  N =< 1).

%-->-------------------------------- - - - - - - - - - -  -  -  -  -  -
% Não permite inserir um contrato caso as entidades do contrato não existam
+contrato(IdAd, IdAda, _, _, _, _, _, _, _, _, _, _) :: 
		(solucoes((IdAd),(adjudicante(IdAd, Nome, NIF, M)),S),
        comprimento(S,N), N == 1,
		solucoes((IdAda),(adjudicataria(IdAda, Nome1, NIF1, M1)),S1),
        comprimento(S1,N1), N1 == 1).

%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Não permite retirar adjudicante caso este tenha um contrato associado
-adjudicante(Id, _, _, _) :: (solucoes((Id),(contrato(Id, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A)),S),
                  		      comprimento(S,N), 
				  		      N == 0).

%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Não permite retirar adjudicataria caso esta tenha um contrato associado
-adjudicataria(Id, _, _, _) :: (solucoes((Id),(contrato(IdAd, Id, IdC, TC, TP, D, V, P, L, DI, M, A)),S),
                  		        comprimento(S,N), 
				  			    N == 0).

%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Impede a inserção de conhecimento negativo repetido
+(-X) :: (solucoes(X, clause(-X, true), S),
		 comprimento(S,N), 
		 N =< 1). 

%--->------------------------------- - - - - - - - - - -  -  -  -  -  -
% Impede contradições entre conhecimento positivo e negativo
+X :: nao(-X).
+(-X) :: nao(X).

%------------------- CONHECIMENTO IMPERFEITO - - - - - - - - - -  -  -  -  -  -

excecaoIncerta(adjudicante(Id, Nome, NIF, M)) :- adjudicante(Id, Nome, xpto1, M).
excecaoInterdita(adjudicante(Id, Nome, NIF, M)) :- adjudicante(Id, Nome, interdito, M).
%----ADJUDICANTE------------------------------ - - - - - - - - - -  -  -  -  -  -
% Conhecimento imperfeito incerto

adjudicante(4, municipio_viseu, xpto1, portugal_viseu).
%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Conhecimento imperfeito impreciso

excecaoImprecisa(adjudicante(5, municipio_braga, 700000010, portugal_braga)).
excecaoImprecisa(adjudicante(5, municipio_braga, 700000020, portugal_braga)).

excecaoImprecisaIntervalo(adjudicante(6, municipio_porto, NIF, portugal_porto), 700000030, 700000050) :- 
		NIF >= 700000030, NIF =< 700000050.
%->--------------------------------- - - - - - - - - - -  -  -  -  -  -
% Conhecimento imperfeito interdito

adjudicante(7, municipio_lisboa, interdito, portugal_lisboa).
nuloInterdito(interdito).

+adjudicante(Id, Nome, NIF, M) :: (solucoes(NIF, 
								  (adjudicante(7, municipio_lisboa, NIF, portugal_lisboa),
								   nao(nuloInterdito(NIF))),S),
								   comprimento(S,N), N==0).
%----ADJUDICATARIA------------------------------ - - - - - - - - - -  -  -  -  -  -

excecaoIncerta(adjudicataria(Id, Nome, NIF, M)) :- adjudicataria(Id, xpto2, NIF, M).
excecaoInterdita(adjudicataria(Id, Nome, NIF, M)) :- adjudicataria(Id, interdito2, NIF, M).
%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Conhecimento imperfeito incerto

adjudicataria(4, xpto2, 711111121, portugal).
%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Conhecimento imperfeito impreciso

excecaoImprecisa(adjudicataria(5, peugaspinto, 711111131, portugal)).
excecaoImprecisa(adjudicataria(5, peugastinto, 711111131, portugal)).
%->--------------------------------- - - - - - - - - - -  -  -  -  -  -
% Conhecimento imperfeito interdito

adjudicataria(6, interdito2, 711111141, portugal).
nuloInterdito(interdito2).

+adjudicataria(Id, Nome, NIF, M) :: (solucoes(Nome, 
								    (adjudicataria(7, Nome, 711111141, portugal),
								     nao(nuloInterdito(Nome))),S),
								     comprimento(S,N), N==0).
%----CONTRATO------------------------------ - - - - - - - - - -  -  -  -  -  -

excecaoIncerta(contrato(IdAd, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A)) :- contrato(IdAd, IdAda, IdC, TC, TP, D, V, xpto3, L, DI, M, A).
excecaoInterdita(contrato(IdAd, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A)) :- contrato(IdAd, IdAda, IdC, TC, TP, D, V, interdito3, L, DI, M, A).
%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Conhecimento imperfeito incerto

contrato(2, 1, 4, locacao_de_bens_moveis, ajuste_direto, assessoriajuridica, 4000, xpto3, braga, 14, 04, 2010).
%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Conhecimento imperfeito impreciso

excecaoImprecisa(contrato(1, 2, 5, contrato_de_aquisicao, ajuste_direto, assessoriajuridica, 5000, 280, lisboa, 15, 05, 2005)).
excecaoImprecisa(contrato(1, 2, 5, contrato_de_aquisicao, ajuste_direto, assessoriajuridica, 5000, 170, lisboa, 15, 05, 2005)).

excecaoImprecisaIntervalo(contrato(3, 2, 7, urgente, concurso_publico, assessoriajuridica, 200000, P, coimbra, 15, 05, 2018), 100, 400) :- 
		P >= 100, P =< 400.
%>---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Conhecimento imperfeito interdito

contrato(1, 2, 6, locacao_de_bens_moveis, consulta_previa, assessoriajuridica, 5000, interdito3, porto, 16, 06, 2017).
nuloInterdito(interdito3).

+contrato(IdAd, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A) :: 
		(solucoes(Px,(contrato(1, 2, 6, locacao_de_bens_moveis, consulta_previa, assessoriajuridica, 5000, Px, porto, 16, 06, 2017),
				  nao(nuloInterdito(Px))), S),
				  comprimento(S,N), N == 0).  	

%------------------- PREDICADOS DE INTERACAO COM A BASE DE CONHECIMENTO - - - - - - - - - -  -  -  -  -  -

%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Lista dos contratos de um determinado adjudicante
% Extensão do predicado contratosAdjudicante: Id, Resultado -> {V,F}
contratosAdjudicante(Id, R) :- 
		solucoes((contrato(IdAd, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A)),
				contrato(Id, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A),R).

%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Lista dos contratos de um determinado adjudicataria
% Extensão do predicado contratosAdjudicataria: Id, Resultado -> {V,F}
contratosAdjudicataria(Id, R) :- 
		solucoes((contrato(IdAd, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A)),
				contrato(IdAd, Id, IdC, TC, TP, D, V, P, L, DI, M, A),R).

%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Número total de contratos celebrados entre determinado adjudicante e adjudicataria
% Extensão do predicado quantosContratos: Id1, Id2, Resultado -> {V,F}
quantosContratos(Id1, Id2, R) :- 
		solucoes((contrato(IdAd, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A)), 
				contrato(Id1, Id2, IdC, TC, TP, D, V, P, L, DI, M, A), L),
		comprimento(L,R).

%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Valor total dos contratos celebrados por determinado adjudicante
% Extensão do predicado valorAcumAdjudicante: Id, Resultado -> {V,F}
valorAcumAdjudicante(Id, R) :- 
		solucoes(V, contrato(Id, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A), L),
				soma(L, R).

%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Valor total dos contratos celebrados por determinada adjudicataria
% Extensão do predicado valorAcumAdjudicataria: Id, Resultado -> {V,F}
valorAcumAdjudicataria(Id, R) :- 
		solucoes(V, contrato(Id, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A), L),
		soma(L, R).							   

%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Lista dos tipos de contrato dos contratos celebrados por determinada adjudicante
% Extensão do predicado tipoContAdjudicante: Id, Resultado -> {V,F}
tipoContAdjudicante(Id, R) :- 
		solucoesSemRep(TC, 
				IdAd^IdAda^IdC^TP^D^V^P^L^DI^M^A^contrato(Id, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A), R).
%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Lista dos tipos de contrato dos contratos celebrados por determinada adjudicataria
% Extensão do predicado tipoContAdjudicataria: Id, Resultado -> {V,F}
tipoContAdjudicataria(Id, R) :- 
		solucoesSemRep(TC, 
				IdAd^IdAda^IdC^TP^D^V^P^L^DI^M^A^contrato(IdAd, Id, IdC, TC, TP, D, V, P, L, DI, M, A), R).

%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Alteração da morada de determinada adjudicataria
% Extensão do predicado atualizaMorada: Morada, Resultado -> {V,F}
atualizaMorada(Id, MoradaNova) :- 
		solucoes((Id, Nome, NIF, M), 
				adjudicataria(Id, Nome, NIF, Morada), 
				[(Idy, Nomey, NIFy, Moraday)]),
		remocao(adjudicataria(Idy, Nomey, NIFy, Moraday)),
		insercao(adjudicataria(Id, Nomey, NIFy, MoradaNova)).	

%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Alteração do nome de determinada adjudicataria
% Extensão do predicado atualizaNome: Nome, Resultado -> {V,F}
atualizaNome(Id, NomeNovo) :- 
		solucoes((Id, Nome, NIF, M), 
				adjudicataria(Id, Nome, NIF, Morada), 
				[(Idy, Nomey, NIFy, Moraday)]),
		remocao(adjudicataria(Idy, Nomey, NIFy, Moraday)),
		insercao(adjudicataria(Id, NomeNovo, NIFy, Moraday)).			

%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Lista dos contratos realizados em determinado local
% Extensão do predicado contratosLocal: Local, Resultado -> {V,F}
contratosLocal(Local, R) :- 
		solucoes((contrato(IdAd, Id, IdC, TC, TP, D, V, P, L, DI, M, A)), 
				contrato(IdAd, Id, IdC, TC, TP, D, V, P, Local, DI, M, A), R).

%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Lista dos contratos com Valor superior/inferior a determinada referência
% Extensão do predicado contratosValor: Valor, Operacao, Resultado -> {V,F}
contratosValor(Valor, =, R) :- 
		solucoes((contrato(IdAd, Id, IdC, TC, TP, D, V, P, L, DI, M, A)), 
				(contrato(IdAd, Id, IdC, TC, TP, D, V, P, L, DI, M, A), V == Valor), R).
contratosValor(Valor, >, R) :- 
		solucoes((contrato(IdAd, Id, IdC, TC, TP, D, V, P, L, DI, M, A)), 
				(contrato(IdAd, Id, IdC, TC, TP, D, V, P, L, DI, M, A), V > Valor), R).
contratosValor(Valor, <, R) :- 
		solucoes((contrato(IdAd, Id, IdC, TC, TP, D, V, P, L, DI, M, A)), 
				(contrato(IdAd, Id, IdC, TC, TP, D, V, P, L, DI, M, A), V =< Valor), R).

%->--------------------------------- - - - - - - - - - -  -  -  -  -  -
% Lista dos contratos que aconteceram numa determinada data
% Extensão do predicado contratosData: Dia, Mes, Ano, Resultado -> {V,F}
contratosData(DI1, M1, A1, R) :- 
		solucoes((contrato(IdAd, Id, IdC, TC, TP, D, V, P, L, DI, M, A)), 
				contrato(IdAd, Id, IdC, TC, TP, D, V, P, L, DI1, M1, A1), R).

%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Lista dos argumentos das adjudicatarias conforme opção
% Extensão do predicado opcoesAdjudicataria: Opcao, Resultado -> {V,F}
opcoesAdjudicataria(1, R) :- 
		solucoes((Id), 
				adjudicataria(Id, Nome, NIF, Morada), R).
opcoesAdjudicataria(2, R) :- 
		solucoes((Nome), 
				adjudicataria(Id, Nome, NIF, Morada), R).
opcoesAdjudicataria(3, R) :- 
		solucoes((NIF), 
				adjudicataria(Id, Nome, NIF, Morada), R).
opcoesAdjudicataria(4, R) :- 
		solucoes((Morada), 
				adjudicataria(Id, Nome, NIF, Morada), R).

%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Lista dos argumentos dos adjudicantes conforme opção
% Extensão do predicado opcoesAdjudicante: Opcao, Resultado -> {V,F}
opcoesAdjudicante(1, R) :- 
		solucoes((Id), 
				adjudicante(Id, Nome, NIF, Morada), R).
opcoesAdjudicante(2, R) :- 
		solucoes((Nome), 
				adjudicante(Id, Nome, NIF, Morada), R).
opcoesAdjudicante(3, R) :- 
		solucoes((NIF), 
				adjudicante(Id, Nome, NIF, Morada), R).
opcoesAdjudicante(4, R) :- 
		solucoes((Morada), 
				adjudicante(Id, Nome, NIF, Morada), R).


%-------------------- EVOLUCAO DE CONHECIMENTO - - - - - -  -  -  -  -  -

% Extensão do meta predicado atualizacao: Termo -> {V,F}										
%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Atualizacao de conhecimento incerto/impreciso para positivo
atualizacao(adjudicante(Id, Nome, NIF, Morada)) :-
		si(excecaoIncerta(adjudicante(Id, Nome, NIF, Morada)), verdadeiro),
		remocao(adjudicante(Id, Nome, xpto1, Morada)),
		remocao((excecaoIncerta(adjudicante(I, N, NI, M)) :- adjudicante(I, N, xpto1, M))),
		insercao(adjudicante(Id, Nome, NIF, Morada));
		si(excecaoImprecisa(adjudicante(Id, Nome, NIF, Morada)), verdadeiro),
		solucoes((excecaoImprecisa(adjudicante(_,_,_,_))), excecaoImprecisa(adjudicante(Id, Nome, _, Morada)), L),
		remocaoLista(L),
		insercao(adjudicante(Id, Nome, NIF, Morada));
		clause(excecaoImprecisaIntervalo(adjudicante(Id,_,_,_),_,_), R),
		remocao((excecaoImprecisaIntervalo(adjudicante(Id,_,N,_), X, Y) :- N >= X, N =<Y )),
		insercao(adjudicante(Id, Nome, NIF, Morada)).

%->-----
atualizacao(adjudicataria(Id, Nome, NIF, Morada)) :-
		si(excecaoIncerta(adjudicataria(Id, Nome, NIF, Morada)), verdadeiro),
		remocao(adjudicataria(Id, xpto2, NIF, Morada)),
		remocao((excecaoIncerta(adjudicataria(I, N, NI, M)) :- adjudicataria(I, xpto2, NI, M))),
		insercao(adjudicataria(Id, Nome, NIF, Morada));
		si(excecaoImprecisa(adjudicataria(Id, Nome, NIF, Morada)), verdadeiro),
		solucoes((excecaoImprecisa(adjudicataria(_,_,_,_))), excecaoImprecisa(adjudicataria(Id, _, NIF, Morada)), L),
		remocaoLista(L),
		insercao(adjudicataria(Id, Nome, NIF, Morada)). 
%->-----
atualizacao(contrato(Id, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A)) :-
		si(excecaoIncerta(contrato(Id, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A)), verdadeiro),
		remocao(contrato(Id, IdAda, IdC, TC, TP, D, V, xpto3, L, DI, M, A)),
		remocao((excecaoIncerta(contrato(I, II, III, T, TT, DD, VV, PP, LL, DII, MM, AA)) :- 
				contrato(I, II, III, T, TT, DD, VV, xpto3, LL, DII, MM, AA))),
		insercao(contrato(Id, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A));
		si(excecaoImprecisa(contrato(Id, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A)), verdadeiro),
		solucoes((excecaoImprecisa(contrato(_, _, _, _, _, _, _, _, _, _, _, _))), 
				excecaoImprecisa(contrato(Id, IdAda, IdC, TC, TP, D, V, _, L, DI, M, A)), L),
		remocaoLista(L),
		insercao(contrato(Id, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A));
		clause(excecaoImprecisaIntervalo(contrato(_, _, IdC, _, _, _, _, _, _, _, _, _),_,_), R),
		remocao((excecaoImprecisaIntervalo(contrato(_, _, IdC, _, _, _, _, PP, _, _, _, _), X, Y) :- PP >= X, PP =<Y )),
		insercao(contrato(Id, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A)).					  

%->--------------------------------- - - - - - - - - - -  -  -  -  -  -
% Atualizacao de conhecimento incerto/impreciso para negativo
atualizacao(-X) :- si(excecaoIncerta(X), verdadeiro),
				   insercao(-X);
				   si(excecaoImprecisa(X), verdadeiro),
				   remocao(excecaoImprecisa(X)),
				   insercao(-X);
				   clause(excecaoImprecisaIntervalo(X,_,_), R),
				   insercao(-X).

%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Atualizacao de conhecimento negativo para positivo		 

atualizacao(adjudicante(Id, Nome, NIF, Morada)) :-
		clause(excecaoIncerta(adjudicante(Id, _, _, _)), Q),
		si(adjudicante(Id,_, xpto1,_), verdadeiro),
		clause(-adjudicante(Id, Nome, NIF, Morada), true),
		solucoes((-adjudicante(Id, NO, N, M)), (-adjudicante(Id, _, _, _)), L1),		
		remocaoLista(L1),
		remocao(adjudicante(Id, _, xpto1, _)),
		remocao((excecaoIncerta(adjudicante(I, N, NI, M)) :- adjudicante(I, N, xpto1, M))),
		insercao(adjudicante(Id, Nome, NIF, Morada));
		clause(excecaoImprecisaIntervalo(adjudicante(Id,_,_,_),_,_), R),
		clause(-adjudicante(Id, Nome, NIF, Morada), true),
		solucoes((-adjudicante(Id, NO, N, M)), (-adjudicante(Id, _, _, _)), L2),		
		remocaoLista(L2),
		remocao((excecaoImprecisaIntervalo(adjudicante(Id,_,N,_), X, Y) :- N >= X, N =<Y )),
		insercao(adjudicante(Id, Nome, NIF, Morada));
		clause(-adjudicante(Id, Nome, NIF, Morada), true),
		solucoes((-adjudicante(Id, NO, N, M)), (-adjudicante(Id, _, _, _)), L3),		
		remocaoLista(L3),
		solucoes((excecaoImprecisa(adjudicante(_,_,_,_))), excecaoImprecisa(adjudicante(Id, _, _, _)), L),
		remocaoLista(L),
		insercao(adjudicante(Id, Nome, NIF, Morada)).
%->---
atualizacao(adjudicataria(Id, Nome, NIF, Morada)) :-
		clause(excecaoIncerta(adjudicataria(Id, _, _, _)), Q),
		si(adjudicataria(Id, xpto2, _, _), verdadeiro),
		clause(-adjudicataria(Id, Nome, NIF, Morada), true),
		solucoes((-adjudicataria(Id, NO, N, M)), (-adjudicataria(Id, _, _, _)), L1),		
		remocaoLista(L1),
		remocao(adjudicataria(Id, xpto2, _, _)),
		remocao((excecaoIncerta(adjudicataria(I, N, NI, M)) :- adjudicataria(I, xpto2, NI, M))),
		insercao(adjudicataria(Id, Nome, NIF, Morada));
		clause(-adjudicataria(Id, Nome, NIF, Morada), true),
		solucoes((-adjudicataria(Id, NO, N, M)), (-adjudicataria(Id, _, _, _)), L2),		
		remocaoLista(L2),	
		solucoes((excecaoImprecisa(adjudicataria(_,_,_,_))), excecaoImprecisa(adjudicataria(Id, _, _, _)), L),
		remocaoLista(L),
		insercao(adjudicataria(Id, Nome, NIF, Morada)).	
%->---
atualizacao(contrato(IdAd, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A)) :-
		clause(excecaoIncerta(contrato(_, _, IdC, _, _, _, _, _, _, _, _, _)), Q),
		si(contrato(_, _, IdC, _, _, _, _, xpto3, _, _, _, _), verdadeiro),
		clause(-contrato(IdAd, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A), true),
		solucoes((-contrato(IdAd, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A)), (-contrato(_, _, IdC, _, _, _, _, _, _, _, _, _)), L1),		
		remocaoLista(L1),
		remocao(contrato(_, _, IdC, _, _, _, _, xpto3, _, _, _, _)),
		remocao((excecaoIncerta(contrato(I, II, III, T, TT, DD, VV, PP, LL, DII, MM, AA)) :- 
				contrato(I, II, III, T, TT, DD, VV, xpto3, LL, DII, MM, AA))),
		insercao(contrato(IdAd, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A));
		clause(excecaoImprecisaIntervalo(contrato(_, _, IdC, _, _, _, _, _, _, _, _, _),_,_), R),
		clause(-contrato(IdAd, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A), true),
		solucoes((-contrato(IdAd, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A)), (-contrato(_, _, IdC, _, _, _, _, _, _, _, _, _)), L2),		
		remocaoLista(L2),
		remocao((excecaoImprecisaIntervalo(contrato(_, _, IdC, _, _, _, _, PP, _, _, _, _), X, Y) :- PP >= X, PP =<Y )),
		insercao(contrato(IdAd, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A));
		clause(-contrato(IdAd, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A), true),
		solucoes((-contrato(IdAd, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A)), (-contrato(_, _, IdC, _, _, _, _, _, _, _, _, _)), L3),		
		remocaoLista(L3),
		solucoes((excecaoImprecisa(contrato(_, _, _, _, _, _, _, _, _, _, _, _))), excecaoImprecisa(contrato(_, _, IdC, _, _, _, _, _, _, _, _, _)), L),
		remocaoLista(L),
		insercao(contrato(IdAd, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A)).		

%->--------------------------------- - - - - - - - - - -  -  -  -  -  -
% Atualizacao de conhecimento positivo para negativo		  
atualizacao(-X) :- clause(X, true), 
				   si(excecaoIncerta(X), desconhecido),
				   remocao(X), 
				   insercao(-X).

%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Atualizacao de conhecimento positivo novo 

atualizacao(adjudicante(Id, Nome, NIF, Morada)) :-
		clause(excecaoImprecisaIntervalo(adjudicante(Id,_,_,_),_,_), R),
		remocao((excecaoImprecisaIntervalo(adjudicante(Id,_,N,_), X, Y) :- N >= X, N =<Y )),
		insercao(adjudicante(Id, Nome, NIF, Morada));
		solucoes((excecaoImprecisa(adjudicante(_,_,_,_))), excecaoImprecisa(adjudicante(Id, _, _, _)), L),
		remocaoLista(L),
		insercao(adjudicante(Id, Nome, NIF, Morada)).
%->
atualizacao(adjudicataria(Id, Nome, NIF, Morada)) :-
		solucoes((excecaoImprecisa(adjudicataria(_,_,_,_))), excecaoImprecisa(adjudicataria(Id, _, _, _)), L),
		remocaoLista(L),
		insercao(adjudicataria(Id, Nome, NIF, Morada)).

atualizacao(contrato(IdAd, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A)) :-
		clause(excecaoImprecisaIntervalo(contrato(_, _, IdC, _, _, _, _, _, _, _, _, _),_,_), R),
		remocao((excecaoImprecisaIntervalo(contrato(_, _, IdC, _, _, _, _, PP, _, _, _, _), X, Y) :- PP >= X, PP =<Y )),
		insercao(contrato(IdAd, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A));
		solucoes((excecaoImprecisa(contrato(_, _, IdC, _, _, _, _, _, _, _, _, _))), excecaoImprecisa(contrato(_, _, IdC, _, _, _, _, _, _, _, _, _)), L),
		remocaoLista(L),
		insercao(contrato(IdAd, IdAda, IdC, TC, TP, D, V, P, L, DI, M, A)).				

%->--------------------------------- - - - - - - - - - -  -  -  -  -  -
% Atualizacao de conhecimento negativo novo 

atualizacao(X) :- insercao(X).

%->--------------------------------- - - - - - - - - - -  -  -  -  -  -

% Extensão do meta predicado atualizacaoIncerto: Entidade, Argumento -> {V,F} (meter NIF como xpto1)									
%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Atualizacao de conhecimento positivo para incerto
atualizacaoIncerto(adjudicante(Id, Nome, NIF, Morada), nif) :-
		si(adjudicante(Id, _, _, _),verdadeiro),
		nao(clause(-adjudicante(Id, Nome, NIF, Morada), true)),
		nao(clause(excecaoImprecisa(adjudicante(Id,_,_,_)), R)),
		nao(clause(excecaoImprecisaIntervalo(adjudicante(Id,_,_,_),_,_), R)),
		solucoes((adjudicante(Id, NO, N, M)), adjudicante(Id, _, _, _), L),
		comprimento(L,R), R == 1,
		remocaoLista(L),
		insercao((excecaoIncerta(adjudicante(I, NO, N, M)) :- adjudicante(I,NO, xpto1, M))),
		insercao(adjudicante(Id, Nome, xpto1, Morada)).		

%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Atualizacao de conhecimento negativo para incerto
atualizacaoIncerto(adjudicante(Id, Nome, NIF, Morada), nif) :-
		clause(-adjudicante(Id, _, _, _),true),
		nao(adjudicante(Id, _, _, _)),
		nao(clause(excecaoImprecisa(adjudicante(Id,_,_,_)), R)),
		nao(clause(excecaoImprecisaIntervalo(adjudicante(Id,_,_,_),_,_), R)),
		solucoes((-adjudicante(Id, NO, N, M)), (-adjudicante(Id, _, _, _)), L),		
		comprimento(L,R), R >= 1,
		remocaoLista(L),
		insercao((excecaoIncerta(adjudicante(I, NO, N, M)) :- adjudicante(I,NO, xpto1, M))),
		insercao(adjudicante(Id, Nome, xpto1, Morada)).

%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Atualizacao de conhecimento impreciso para incerto
atualizacaoIncerto(adjudicante(Id, Nome, NIF, Morada), nif) :-
		nao(adjudicante(Id, _, _, _)),
		nao(clause(-adjudicante(Id, Nome, NIF, Morada), true)),
		si(excecaoImprecisa(adjudicante(Id, Nome, NIF, Morada)), verdadeiro),
		solucoes((excecaoImprecisa(adjudicante(_,_,_,_))), excecaoImprecisa(adjudicante(Id, Nome, _, Morada)), L),
		remocaoLista(L),
		remocao((excecaoImprecisa(adjudicante(Id,_,N,_)))),
		insercao((excecaoIncerta(adjudicante(I, NO, N, M)) :- adjudicante(I,NO, xpto1, M))),
		insercao(adjudicante(Id, Nome, xpto1, Morada)).
atualizacaoIncerto(adjudicante(Id, Nome, NIF, Morada), nif) :-
		nao(adjudicante(Id, _, _, _)),
		nao(clause(-adjudicante(Id, Nome, NIF, Morada), true)),
		nao(clause(excecaoImprecisa(adjudicante(Id,_,_,_)), R)),
		clause(excecaoImprecisaIntervalo(adjudicante(Id,_,_,_),_,_), R),
		remocao((excecaoImprecisaIntervalo(adjudicante(Id,_,N,_), X, Y) :- N >= X, N =<Y )),
		insercao((excecaoIncerta(adjudicante(I, NO, N, M)) :- adjudicante(I,NO, xpto1, M))),
		insercao(adjudicante(Id, Nome, xpto1, Morada)).		

%->--------------------------------- - - - - - - - - - -  -  -  -  -  -
% Atualizacao de conhecimento incerto novo 
atualizacaoIncerto(adjudicante(Id, Nome, NIF, Morada), nif) :-
		nao(adjudicante(Id, _, _, _)),
		nao(clause(-adjudicante(Id, Nome, NIF, Morada), true)),
		nao(clause(excecaoImprecisa(adjudicataria(Id,_,_,_)), R)),
		nao(clause(excecaoImprecisaIntervalo(adjudicataria(Id,_,_,_),_,_), R)),
		insercao((excecaoIncerta(adjudicante(I, NO, N, M)) :- adjudicante(I,NO, xpto1, M))),
		insercao(adjudicante(Id, Nome, xpto1, Morada)).


%---------------------------------- - - - - - - - - - -  -  -  -  -  -

% Extensão do meta predicado atualizacaoImpreciso: Entidade, Argumento -> {V,F}										
%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Atualizacao de conhecimento positivo para impreciso
atualizacaoImpreciso(adjudicante(Id, Nome, NIF, Morada), nif) :-
		si(excecaoIncerta(adjudicante(Id, Nome, NIF, Morada)), desconhecido),
		si(adjudicante(Id, _, _, _),verdadeiro),
		nao(clause(-adjudicante(Id, Nome, NIF, Morada), true)),
		solucoes((adjudicante(Id, NO, N, M)), adjudicante(Id, _, _, _), L),
		comprimento(L,R), R == 1,
		remocaoLista(L),
		insercao((excecaoImprecisa(adjudicante(Id, Nome, NIF, Morada)))).		
atualizacaoImpreciso(adjudicante(Id, Nome, NIF, Morada), nif, INF, SUP) :-
		si(adjudicante(Id, _, _, _),verdadeiro),
		nao(clause(-adjudicante(Id, Nome, NIF, Morada), true)),
		solucoes((adjudicante(Id, NO, N, M)), adjudicante(Id, _, _, _), L),
		comprimento(L,R), R == 1,
		remocaoLista(L),
		insercao((excecaoImprecisaIntervalo(adjudicante(Id, Nome, NI, Morada), INF, SUP) :- 
				NI >= INF, NI =< SUP)).		


%->--------------------------------- - - - - - - - - - -  -  -  -  -  -
% Atualizacao de conhecimento negativo para impreciso
atualizacaoImpreciso(adjudicante(Id, Nome, NIF, Morada), nif) :-
		clause(-adjudicante(Id, _, _, _),true),
		nao(adjudicante(Id, _, _, _)),
		solucoes((-adjudicante(Id, NO, N, M)), (-adjudicante(Id, _, _, _)), L),		
		comprimento(L,R), R >= 1,
		remocaoLista(L),
		insercao((excecaoImprecisa(adjudicante(Id, Nome, NIF, Morada)))).
atualizacaoImpreciso(adjudicante(Id, Nome, NIF, Morada), nif, INF, SUP)  :-
		clause(-adjudicante(Id, _, _, _),true),
		nao(adjudicante(Id, _, _, _)),
		solucoes((-adjudicante(Id, NO, N, M)), (-adjudicante(Id, _, _, _)), L),		
		comprimento(L,R), R >= 1,
		remocaoLista(L),
		insercao((excecaoImprecisaIntervalo(adjudicante(Id, Nome, NI, Morada), INF, SUP) :- 
				NI >= INF, NI =< SUP)).

%>---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Atualizacao de conhecimento incerto para impreciso
atualizacaoImpreciso(adjudicante(Id, Nome, NIF, Morada), nif) :-
		nao(clause(-adjudicante(Id, Nome, NIF, Morada), true)),
		clause(excecaoIncerta(adjudicante(Id, _, _, _)), Q),
		si(adjudicante(Id,_, xpto1,_), verdadeiro),
		remocao(adjudicante(Id, _, xpto1, _)),
		remocao((excecaoIncerta(adjudicante(I, N, NI, M)) :- adjudicante(I, N, xpto1, M))),
		insercao((excecaoImprecisa(adjudicante(Id, Nome, NIF, Morada)))).
atualizacaoImpreciso(adjudicante(Id, Nome, NIF, Morada), nif, INF, SUP) :-
		nao(adjudicante(Id, _, _, _)),
		nao(clause(-adjudicante(Id, Nome, NIF, Morada), true)),
		clause(excecaoIncerta(adjudicante(Id, _, _, _)), Q),
		si(adjudicante(Id,_, xpto1,_), verdadeiro),
		remocao(adjudicante(Id, _, xpto1, _)),
		remocao((excecaoIncerta(adjudicante(I, N, NI, M)) :- adjudicante(I, N, xpto1, M))),
		insercao((excecaoImprecisaIntervalo(adjudicante(Id, Nome, NI, Morada), INF, SUP) :- 
				NI >= INF, NI =< SUP)).	
%>---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Atualizacao de conhecimento impreciso novo 
atualizacaoImpreciso(adjudicante(Id, Nome, NIF, Morada), nif) :-
		nao(adjudicante(Id, Nome, NIF, Morada)),
		nao(clause(-adjudicante(Id, Nome, NIF, Morada), true)),
		insercao((excecaoImprecisa(adjudicante(Id, Nome, NIF, Morada)))).
atualizacaoImpreciso(adjudicante(Id, Nome, NIF, Morada), nif, INF, SUP) :-
		nao(adjudicante(Id, Nome, NIF, Morada)),
		nao(clause(-adjudicante(Id, Nome, NIF, Morada), true)),
		insercao((excecaoImprecisa(adjudicante(Id, Nome, N, Morada)) :-
			N >= INF, N =< SUP)).	

%->--------------------------------- - - - - - - - - - -  -  -  -  -  -

% Extensão do meta predicado atualizacaoInterdito: Entidade, Argumento -> {V,F} (meter NIF como xpto1)									
%---------------------------------- - - - - - - - - - -  -  -  -  -  -
% Atualizacao de conhecimento positivo para interdito
atualizacaoInterdito(adjudicante(Id, Nome, NIF, Morada), nif) :-
		solucoes(Inv, +adjudicante(Id,Nome,NIF,Morada) :: Inv, Sol),
		nao(nuloInterdito(NIF)),
		si(excecaoIncerta(adjudicante(Id, Nome, NIF, Morada)), desconhecido),
		si(adjudicante(Id, _, _, _),verdadeiro),
		nao(clause(-adjudicante(Id, _, _, _), true)),
		nao(clause(excecaoImprecisa(adjudicante(Id,_,_,_)), R)),
		nao(clause(excecaoImprecisaIntervalo(adjudicante(Id,_,_,_),_,_), R)),
		solucoes((adjudicante(Id, NO, N, M)), adjudicante(Id, _, _, _), L),
		comprimento(L,R), R == 1,
		remocaoLista(L),
		insercao((adjudicante(Id, Nome, interdito, Morada))),
		insercao((excecaoInterdita(adjudicante(A,B,C,D)) :- adjudicante(A,B,interdito,D))),
		insercao((nuloInterdito(interdito))),
		insercao((+adjudicante(I, N, NI, M) :: (solucoes(Nif, 
						(adjudicante(Id, Nome, Nif, Morada), nao(nuloInterdito(Nif))),S),
						comprimento(S,N), N==0))),
		teste(Sol).

% Atualizacao de conhecimento negativo para interdito
atualizacaoInterdito(adjudicante(Id, Nome, NIF, Morada), nif) :-
		solucoes(Inv, +adjudicante(Id,Nome,NIF,Morada) :: Inv, Sol),
		nao(nuloInterdito(NIF)),
		clause(-adjudicante(Id, _, _, _), true),
		nao(clause(excecaoImprecisa(adjudicante(Id,_,_,_)), R)),
		nao(clause(excecaoImprecisaIntervalo(adjudicante(Id,_,_,_),_,_), R)),
		solucoes((-adjudicante(Id, NO, N, M)), (-adjudicante(Id, _, _, _)), L),
		comprimento(L,R), R >= 1,
		remocaoLista(L),
		insercao((adjudicante(Id, Nome, interdito, Morada))),
		insercao((excecaoInterdita(adjudicante(A,B,C,D)) :- adjudicante(A,B,interdito,D))),
		insercao((nuloInterdito(interdito))),
		insercao((+adjudicante(I, N, NI, M) :: (solucoes(Nif, 
						(adjudicante(Id, Nome, Nif, Morada), nao(nuloInterdito(Nif))),S),
						comprimento(S,N), N==0))),
		teste(Sol).

% Atualizacao de conhecimento incerto/impreciso para interdito
atualizacaoInterdito(adjudicante(Id, Nome, NIF, Morada), nif) :-
		solucoes(Inv, +adjudicante(Id,Nome,NIF,Morada) :: Inv, Sol),
		nao(nuloInterdito(NIF)),
		nao(clause(-adjudicante(Id, Nome, NIF, Morada), true)),
		clause(excecaoIncerta(adjudicante(Id, _, _, _)), Q),
		si(adjudicante(Id,_, xpto1,_), verdadeiro),
		remocao(adjudicante(Id, _, xpto1, _)),
		remocao((excecaoIncerta(adjudicante(I, N, NI, M)) :- adjudicante(I, N, xpto1, M))),
		insercao((adjudicante(Id, Nome, interdito, Morada))),
		insercao((excecaoInterdita(adjudicante(A,B,C,D)) :- adjudicante(A,B,interdito,D))),
		insercao((nuloInterdito(interdito))),
		insercao((+adjudicante(I, N, NI, M) :: (solucoes(Nif, 
						(adjudicante(Id, Nome, Nif, Morada), nao(nuloInterdito(Nif))),S),
						comprimento(S,N), N==0))),
		teste(Sol);
		solucoes(Inv, +adjudicante(Id,Nome,NIF,Morada) :: Inv, Sol),
		nao(nuloInterdito(NIF)),
		nao(adjudicante(Id, _, _, _)),
		nao(clause(-adjudicante(Id, Nome, NIF, Morada), true)),
		si(excecaoImprecisa(adjudicante(Id, Nome, NIF, Morada)), verdadeiro),
		solucoes((excecaoImprecisa(adjudicante(_,_,_,_))), excecaoImprecisa(adjudicante(Id, Nome, _, Morada)), L),
		remocaoLista(L),
		remocao((excecaoImprecisa(adjudicante(Id,_,N,_)))),
		insercao((adjudicante(Id, Nome, interdito, Morada))),
		insercao((excecaoInterdita(adjudicante(A,B,C,D)) :- adjudicante(A,B,interdito,D))),
		insercao((nuloInterdito(interdito))),
		insercao((+adjudicante(I, N, NI, M) :: (solucoes(Nif, 
						(adjudicante(Id, Nome, Nif, Morada), nao(nuloInterdito(Nif))),S),
						comprimento(S,N), N==0))),
		teste(Sol);
		solucoes(Inv, +adjudicante(Id,Nome,NIF,Morada) :: Inv, Sol),
		nao(nuloInterdito(NIF)),
		nao(adjudicante(Id, _, _, _)),
		nao(clause(-adjudicante(Id, Nome, NIF, Morada), true)),
		nao(clause(excecaoImprecisa(adjudicante(Id,_,_,_)), R)),
		clause(excecaoImprecisaIntervalo(adjudicante(Id,_,_,_),_,_), R),
		remocao((excecaoImprecisaIntervalo(adjudicante(Id,_,N,_), X, Y) :- N >= X, N =<Y )),
		insercao((adjudicante(Id, Nome, interdito, Morada))),
		insercao((excecaoInterdita(adjudicante(A,B,C,D)) :- adjudicante(A,B,interdito,D))),
		insercao((nuloInterdito(interdito))),
		insercao((+adjudicante(I, N, NI, M) :: (solucoes(Nif, 
						(adjudicante(Id, Nome, Nif, Morada), nao(nuloInterdito(Nif))),S),
						comprimento(S,N), N==0))),
		teste(Sol).
		

%>
% Atualizacao de conhecimento interdito novo
atualizacaoInterdito(adjudicante(Id, Nome, NIF, Morada), nif) :-
		solucoes(Inv, +adjudicante(Id,Nome,NIF,Morada) :: Inv, Sol),
		nao(nuloInterdito(NIF)),
		nao(adjudicante(Id, _, _, _)),
		nao(clause(-adjudicante(Id, Nome, NIF, Morada), true)),
		nao(clause(excecaoImprecisa(adjudicante(Id,_,_,_)), R)),
		nao(clause(excecaoImprecisaIntervalo(adjudicante(Id,_,_,_),_,_), R)),
		insercao((adjudicante(Id, Nome, interdito, Morada))),
		insercao((excecaoInterdita(adjudicante(A,B,C,D)) :- adjudicante(A,B,interdito,D))),
		insercao((nuloInterdito(interdito))),
		insercao((+adjudicante(I, N, NI, M) :: (solucoes(Nif, 
						(adjudicante(Id, Nome, Nif, Morada), nao(nuloInterdito(Nif))),S),
						comprimento(S,N), N==0))),
		teste(Sol).						


%>------------------- PREDICADOS AUXILIARES - - - - - - - - - -  -  -  -  -  -

%---------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do meta predicado si: questao, resposta -> {V, F, D}

si(Questao, verdadeiro) :- Questao.
si(Questao, falso) :- -Questao.
si(Questao, desconhecido) :- nao(Questao), nao(-Questao).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do meta predicado nao: Questao -> {V, F}

nao(Questao) :- Questao, !, fail.
nao(Questao).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado evolucao: Termo -> {V,F}

evolucao(Termo) :- solucoes(Invariante, +Termo :: Invariante, Lista), 
				   atualizacao(Termo), 
				   teste(Lista).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado involucao: Termo -> {V,F}

involucao(Termo) :- solucoes(Invariante, -Termo :: Invariante, Lista),
					remocao(Termo), 
					teste(Lista).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensão do predicado insercao: Termo -> {V,F}

insercao(Termo) :- assert(Termo).
insercao(Termo) :- retract(Termo), !, fail.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensão do predicado remocao: Termo -> {V,F}

remocao(Termo) :- retract(Termo).
remocao(Termo) :- assert(Termo),!,fail.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado remocaoLista: Lista -> {V,F}

remocaoLista([]).
remocaoLista([H]) :- remocao(H).
remocaoLista([H|T]) :- remocao(H), remocaoLista(T).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensão do predicado teste: Lista -> {V,F}

teste([]).
teste([R|LR]) :- R, teste(LR).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensão do predicado solucoes: Termo, Questão, Resultado -> {V,F}

solucoes(X, Y, Z) :- findall(X, Y, Z).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensão do predicado solucoesSemRep: Termo, Questão, Resultado -> {V,F}

solucoesSemRep(X, Y, Z) :- setof(X, Y, Z).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensão do predicado comprimento: Lista, Resultado -> {V,F}

comprimento(S,N) :- length(S,N).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensão do predicado soma: Lista, Resultado -> {V,F}

soma([],0).
soma([H|T],R) :- soma(T,R1), R is R1+H.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensão do predicado apagaUltimo: Lista, Lista -> {V,F}

apagaUltimo([],[]).
apagaUltimo([X], []).
apagaUltimo([H|T], [H|R]) :- apagaUltimo(T, R).	

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensão do predicado apagaUltimo: Lista, Lista -> {V,F}

apagaPrimeiro([],[]).
apagaPrimeiro([X], []).
apagaPrimeiro([H|T], T).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% concatenar: Lista, Lista, Resultado -> {V,F}.
concatenar([],L,L).
concatenar([H|T],[H1|T1], [H|L]) :- concatenar(T, [H1|T1], L).
