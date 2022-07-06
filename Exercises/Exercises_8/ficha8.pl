%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Programacao em logica estendida
% Representacao de conhecimento imperfeito

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: Declaracoes iniciais

:- set_prolog_flag(discontiguous_warnings, off).
:- set_prolog_flag(single_var_warnings, off).
:- set_prolog_flag(unknown, fail).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: definicoes iniciais

:- set_prolog_flag( single_var_warnings,off ).
:- op(900, xfy, '::').
:- dynamic '-'/1.
:- dynamic servico/2.
:- dynamic ato/4.

%--------------------------------- - - - - - - - - - -  -  -  -  -   - alinea a
% Extensao do predicado servico : Especialidade, Enfermeira -> {V, F, D}

-servico(Especialidade, Enfermeira) :- nao(servico(Especialidade, Enfermeira)), nao(excecao(servico(Especialidade, Enfermeira))).

% Extensao do predicado ato : Tratamento, Enfermeira, Utente, Data -> {V, F, D}

-ato(Tratamento, Enfermeira, Utente, Data) :- nao(ato(Tratamento, Enfermeira, Utente, Data)), nao(excecao(ato(Tratamento, Enfermeira, Utente, Data))).


%--------------------------------- - - - - - - - - - -  -  -  -  -   - alinea b

servico(ortopedia, amelia).
servico(obstetricia, ana).
servico(obstetricia, maria).
servico(obstetricia, mariana).
servico(geriatria, sofia).
servico(geriatria, susana).
excecao(servico(x007, teodora)).
excecao(servico(np9, zulmira)).

ato(penso, ana, joana, sabado).
ato(gesso, amelia, jose, domingo).
excecao(ato(x017, mariana, joaquina, domingo)).
excecao(ato(domicilio, maria, x121, x251)).
excecao(ato(domicilio, susana, Utente, segunda)) :- pertence(Utente, [joao, jose]).
excecao(ato(sutura, x313, josue, segunda)).
excecao(ato(sutura, Enfermeira, josefa, Data)) :- pertence(Enfermeira, [maria, mariana]), pertence(Data, [terca, sexta]).
excecao(ato(penso, ana, jacinta, Data)) :- pertence(Data, [segunda, terca, quarta, quinta, sexta]).


%--------------------------------- - - - - - - - - - -  -  -  -  -   - alinea c

+ato(_, _, _, D) :: (solucoes(D, feriado(D), S), comprimento(S, N), N == 0).


%--------------------------------- - - - - - - - - - -  -  -  -  -   - alinea d

-servico(_, E) :: (solucoes(E, ato(T, E, U, D), S1), comprimento(S1, N1), N1 == 0, solucoes(E, excecao(ato(T, E, U, D)), S2), comprimento(S2, N2), N2 == 0).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do meta predicado si: questao, resposta -> {V, F, D}

si(Questao, verdadeiro) :- Questao.
si(Questao, falso) :- -Questao.
si(Questao, desconhecido) :- nao(Questao), nao(-Questao).

% Extensao do predicado que permite a evolucao do conhecimento

evolucao(Termo) :- solucoes(Invariante, +Termo :: Invariante, Lista), insercao(Termo), teste(Lista).

insercao(Termo) :- assert(Termo).
insercao(Termo) :- retract(Termo), !, fail.

teste([]).
teste([R|LR]) :- R, teste(LR).

% Extensão do predicado que permite a involucao do conhecimento

involucao(Termo) :- solucoes(Invariante, -Termo :: Invariante, Lista), remocao(Termo), teste(Lista).

remocao(Termo) :- retract(Termo).
remocao(Termo) :- assert(Termo),!,fail.

% Extensao do meta predicado nao: Questao -> {V, F}

nao(Questao) :- Questao, !, fail.
nao(Questao).

% Extensao de predicados auxiliares

pertence(Nome, [Nome|T]).
pertence(Nome, [H|T]) :- pertence(Nome, T).

solucoes(X, Y, Z) :- findall(X, Y, Z).

comprimento(S, N) :- length(S, N).