%21
  filho(joao, jose). (true)

%22
  pai(jose, joao).
= filho(joao, jose). (true)

%23
  sexo(joao, masculino). (true)

%24
  sexo(jose, feminino). (false)

%25
  filho(N, jose).
  N = joao?
  N = carlos?

%26
  filho(jose, joao). (false)

%27
  avo(manuel, jose). (false)

%28
  avo(manuel, joao).
= pai(X, joao), pai(manuel, X).
  X = jose

%29
  neto(carlos, A).
  A = manuel?

%30
  descendente(joao, manuel).
= 

%31
  filho(F, jose), descendente(F, manuel).

%32
  descendente(X, manuel), filho(F, jose).

%33
  graudesc(joao, jose, G).

%34
  graudesc(joao, jose, 2).

%35
  graudesc(joao, manuel, G).

%36
  graudesc(joao, manuel, G), G > 2.