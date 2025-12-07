/* QUESTÃO 01 - A calculator - (a) */

/* "2^100 == (2^10)^10 == 1024^10" */

declare Base Meio Final

Base = 2

Meio = Base * Base * Base * Base * Base * Base * Base * Base * Base * Base

Final = Meio * Meio * Meio * Meio * Meio * Meio * Meio * Meio * Meio * Meio

{Browse Final}

/* ******************************************************************************************************* */

/* QUESTÃO 01 - A calculator - (b) */

declare Resultado

Resultado = 2 * 3 * 4 * 5 * 6 * 7 * 8 * 9 * 10 * 11 * ... * 99 * 100 

{Browse Resultado}

/* Isso não funciona, mas a idéia é esta, pois não há atalhos matemáticos exatos e, conforme dado 
na questão, não podemos criar uma nova função. */

declare Resultado = {NewCell 1} 
for I in 1..100 do Resultado := @Resultado * I end
{Browse @Resultado}
end

/* Isso funciona, e não foi criada nenhuma nova função. */

/* ******************************************************************************************************* */

/* Questão 02 - Calculating combinations - (a) */

declare
    fun {Fact N}
        if N==0 then 1 else N*{Fact N-1} end
end

declare
    fun {Fact2 N N_inicial K}
        if N==N_inicial-K+1 then N else N*{Fact2 N-1 N_inicial K} end
end

declare
    fun {Comb N K}
        {Fact2 N N K} div {Fact K}
end

{Browse {Comb 5 3}} /* exemplo */

/* Questão 02 - Calculating combinations - (b) */

declare
    fun {Fact N}
        if N==0 then 1 else N*{Fact N-1} end
end

declare
    fun {Fact2 N N_inicial K}
        if N==N_inicial-K+1 then N else N*{Fact2 N-1 N_inicial K} end
end

declare
    fun {Comb N K}
        {Fact2 N N K} div {Fact K}
end

declare
    fun {Comb2 N K}
        if K > (N div 2) then {Fact2 N N N-K} div {Fact N-K}
        else {Fact2 N N K} div {Fact K} end
end

{Browse {Comb 5 3}} /* exemplo */

{Browse {Comb2 5 3}} /* exemplo */

/* ******************************************************************************************************* */

/* Questão 03 - Program correctness */

declare Pascal AddList ShiftLeft ShiftRight

    fun {Pascal N}
        if N==1 then [1]
        else {AddList {ShiftLeft {Pascal N-1}} {ShiftRight {Pascal N-1}}} end
end

fun {ShiftLeft L}
    case L of H|T then H|{ShiftLeft T}
    else [0] end
end

fun {ShiftRight L} 0|L end

fun {AddList L1 L2}
    case L1 of H1|T1 then
        case L2 of H2|T2 then
            H1+H2|{AddList T1 T2} 
        end
    else nil end
end

/*
O objetivo da questão é provar a corretude da função Pascal ( por isso coloquei todas as funções auxiliares ).

Caso base [ N == 1 ]: retorna 1, que é correto.

Hipótese [ Pascal(N-1) ]: Supomos que retorna a N-1ésima linha do triângulo de pascal corretamente.

Passo [ Pascal(N) ]: {AddList {ShiftLeft {Pascal N-1}} {ShiftRight {Pascal N-1}}}
- ShiftLeft copia todos os elementos e acrescenta um 0 ao final
- ShiftRight acrescenta um 0 ao início e copia todos os elementos
- AddList soma as duas listas resultantes, elementos a elemento.

A lista resultante (N-ésima linha) será composta por:
- Primeiro elemento é o mesmo primeiro da lista anterior ( L[0] + 0 = 1)
- Último elemento é o mesmo último da lista anterior ( 0 + L[N-1] = 1 )
- Cada elemento é a soma dos dois vizinhos da lista anterior

E isso é justamente a definição matemática do triângulo de Pascal.

Dito isso, a função está provada que é correta.
*/

/* ******************************************************************************************************* */

/* Questão 04 - Program complexity */

/* Os programas com complexidade de polinômio de alta ordem são os que, ao aumentar bastante o "tamanho" da entrada, o tempo para o resultado fica cada vez mais demorado. Definitivamente não são "práticos", pois provavelmente há uma forma mais otimizada de solucionar o mesmo problema.    
*/

/* ******************************************************************************************************* */

/* Questão 05 - Lazy evaluation */

declare SumList Ints

fun lazy {Ints N}
    N|{Ints N+1}
end

fun {SumList L}
    case L of X|L1 then X+{SumList L1}
    else 0 end
end

{Browse{SumList {Ints 0}}}

/* FATAL: The active memory (732105270) after a GC is over the maximal heap size threshold: 732096600
Terminated VM 1 

E isso tem uma explicação lógica...

A função Ints(0) gera uma lista infinita, e a função SumList(Ints(0)) está tentando somar cada elemento, ou seja, ela "precisa" de cada elemento, fazendo o fato da função Ints ser lazy nada importante. E aí, acaba entrando numa recursão infinita, e assim, o buffer se sobrecarrega.
*/

/* ******************************************************************************************************* */

/* Questão 06 - Higher-order programming - (a) */

declare GenericPascal OpList ShiftLeft ShiftRight Add Sub Mul Mul1

fun {GenericPascal Op N}
    if N==1 then [1]
    else L in
        L={GenericPascal Op N-1}
        {OpList Op {ShiftLeft L} {ShiftRight L}}
    end
end

fun {ShiftLeft L}
    case L of H|T then H|{ShiftLeft T}
    else [0] end
end

fun {ShiftRight L} 0|L end

fun {OpList Op L1 L2}
    case L1 of H1|T1 then
        case L2 of H2|T2 then
            {Op H1 H2}|{OpList Op T1 T2}
        end
    else nil end
end

fun {Add X Y} X + Y end

fun {Sub X Y} X - Y end

fun {Mul X Y} X * Y end /* tudo fica zerado quando N > 1 pois ao fazer os shifts, os valores iniciam com 0, e ficam se multiplicando */

fun {Mul1 X Y} (X+1) * (Y+1) end

{Browse {GenericPascal Mul1 10}}

/* Questão 06 - Higher-order programming - (b) */

for I in 1..10 do {Browse {GenericPascal Add I}} end

/* ******************************************************************************************************* */

/* Questão 07 - Explicit state */

local X in
    X=23
    local X in
        X=44
    end
    {Browse X} /* Nesse Browse, é mostrado 23, pois o escopo que possui o identificador X com varíavel de valor 44 já foi finalizado. */
end

local X in
    X={NewCell 23}
    X:=44
    {Browse @X} /* Nesse Browse, é mostrado 44, pois ao criarmos uma célula, ela deixa de ser uma variável imutável, e assim, teve seu valor alterado para 44, no mesmo escopo. */
end

/* ******************************************************************************************************* */

/* Questão 08 - Explicit state and functions */

declare
    fun {Accumulate N}
    Acc in
        Acc={NewCell 0}
        Acc:=@Acc+N
        @Acc
end

/* Essa definição está errada pois a cada vez que a função é chamada, é criada uma nova célula zerada e sobrescreve ao seu estado anterior, e depois somada ao valor N dado como parâmetro */

declare
    Acc = {NewCell 0}
    fun {Accumulate N}
        Acc:=@Acc+N
        @Acc
end

/* Essa definição está correta pois a nova célula zerada é criada somente uma vez, e depois é somada ao valor N dado como parâmetro */

{Browse {Accumulate 5}} /* Acc == 5 */
{Browse {Accumulate 100}} /* Acc == 100 + 5 == 105 */
{Browse {Accumulate 45}} /* Acc == 105 + 45 == 150 */

/* ******************************************************************************************************* */

/* Questão 09 - Memory store */

% The memory store as used in the exercises
declare

fun {NewStore}
   D={NewDictionary}
   C={NewCell 0}
   proc {Put K X}
      if {Not {Dictionary.member D K}} then
         C:=@C+1
      end
      D.K:=X
   end
   fun {Get K} D.K end
   fun {Size} @C end
in
   storeobject(put:Put get:Get size:Size)
end
proc {Put S K X} {S.put K X} end
fun {Get S K} {S.get K} end
fun {Size S} {S.size} end

declare S={NewStore}

{Put S 2 [22 33]}
{Browse {Get S 2}}
{Browse {Size S}} 

/* ******************************************************************************************************* */

/* Questão 10 - Explicit state and concurrency - (a) */

declare
    C={NewCell 0}
    thread I in
        I=@C
        C:=I+1
    end
    thread J in
        J=@C    
        C:=J+1
    end

{Browse @C}


/* Em todas tentativas, o resultado para o valor de C é 0. Isso quer dizer que o processo de Browse é mais rápido que os processos de incremento das threads, mas isso não é determinístico. */

/* Questão 10 - Explicit state and concurrency - (b) */

declare
    C={NewCell 0}
    thread I in
        I=@C
        C:=I+1
    end
    thread J in
        {Delay 20}
        J=@C    
        C:=J+1
    end

{Delay 10}
{Browse @C}

/* Assim, o resultado é sempre 1 */

/* Questão 10 - Explicit state and concurrency - (c) */

declare
    C={NewCell 0}
    L={NewLock}
    thread
        lock L then I in
            I=@C
            C:=I+1
        end
end
    thread
        lock L then J in
            J=@C
            C:=J+1
    end
end
{Browse @C}

/* Nesse caso, mesmo se fosse adicionado um delay, o lck garante que a segunda thread vai iniciar após o fim da primeira, não ocorrendo o caso específico que o resultado seja 1 */