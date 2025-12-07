/* QUESTÃO 01 - Thread semantics. */

local B in
   thread B=true end
   thread B=false end
if B then {Browse yes} end
end

/*
    a) Enumerate all possible executions of this statement.

É possível que hajam execuções diferentes, pois, por conta das threads, não existe uma ordem garantida. Então, há as seguintes opções:

* variável B criada - B se liga a valor verdadeiro - checa valor de B e faz {Browse yes} - B se liga a valor falso - Erro de ligação;

* variável B criada - B se liga a valor falso - checa valor de B e não faz nada - B se liga a valor falso - Erro de ligação;

* variável B criada - B se liga a valor verdadeiro - B se liga a valor falso - Erro de ligação;

* variável B criada - B se liga a valor falso - B se liga a valor verdadeiro - Erro de ligação;

    b) Some of these executions cause the program to terminate abnormally. Make small change to the program to avoid these abnormal terminations.

Para evitar tais terminação anormais, podemos fazer com que a checagem do valor de B seja feita em uma thread separada, assim:

*/

local B in
    thread B=true end
    if B then {Browse yes}
    else thread B=false end
    end
end

/* QUESTÃO 02 - Threads and garbage collection. */

declare A B
proc {B _}
    {Wait _}
end

proc {A}
    Collectible={NewDictionary}
in
    {B Collectible}
end

{A}

/*
O argumento do procedimento B é uma variável ligada ( dicionário criado em A), então quando acontece a chamada {B Collectible}, a variável é passada para o procedimento B, que, por sua vez, utiliza do procedimento wait, que espera uma variável ser ligada. Porém, a variável já está ligada, então o procedimento B termina, e, assim, o procedimento A também termina. E como não há mais referências para o dicionário criado em A, o coletor de lixo pode removê-lo da memória.}}

*/

/* QUESTÃO 03 - Concurrent Fibonacci. */
declare
fun {Fib X}
   if X =< 2 then 1
   else {Fib X-1} + {Fib X-2} end
end

fun {ConcurrentFib X}
   if X =< 2 then 1
   else thread {Fib X-1} end + {Fib X-2} end
end

{Browse {Fib 40}} % 25.88 segundos
{Browse {ConcurrentFib 40}} % 25.79 segundos

/* Dito isso, a diferença do tempo de execução entre ambas funções é mínimo */

/* QUESTÃO 04 - Order-determining concurrency. */

declare A B C D
thread D=C+1 end
thread C=B+1 end
thread A=1 end
thread B=A+1 end
{Browse D}

/*
São criadas 4 threads, e não conseguimos garantir em qual ordem foram criadas ( apesar da mais provável ser a ordem que foram definidas ).

Com relação a ordem, pelo comportamento dataflow das threads ( suspend and resume ), tem-se:
D -> precisa do valor de C.
C -> precisa do valor de B.
A -> foi definido.
B -> precisa do valor de A e é definido.
C -> foi definido.
D -> foi definido ( resultado ).

Com relação ao valor, o resultado é 4.
*/

declare A B C D
A=1
B=A+1
C=B+1
D=C+1
{Browse D}

/*
As adições seguem a ordem que foram definidas, pois:

A -> foi definido.
B -> precisa de A e é definido.
C -> precisa de B e é definido.
D -> precisa de C e é definido ( resultado ).

Com relação ao valor, o resultado é 4.

Logo, independentemente da ordem feita ( por conta do comportamento dataflow das threads ) e do uso da concorrência, o resultado é o mesmo, pois não há "conflito" entre variáveis.
*/

/* QUESTÃO 05 - The Wait operation. */
declare Wait
proc {Wait X}
    if X == unit then skip else skip end
end

/*
A intuição para isso se baseia na forma como o if e as comparações lógicas funcionam em Oz.
o comando if e as comparações lógicas esperam duas expressões ( variáveis ) ligadas, e, por definição, unit é um atom. Então, enquanto X não for ligado, o comando if ficará esperando ele ter valor ( pois não é possível comparar algo não ligado com algo ligado ). E quando X for ligado, independente de ser igual o atom unit, acontecerá o comando skip.
Logo, o comando Wait realmente pode ser definido assim.
*/

/* QUESTÃO 08 - Dataflow behavior in a concurrent setting. */
declare
fun {Filter In F}
    case In
    of X|In2 then
        if {F X} then X|{Filter In2 F}
        else {Filter In2 F} end
    else
        nil
    end
end

{Show {Filter [5 1 2 4 0] fun {$ X} X>2 end}} % [5 4]

declare A
{Show {Filter [5 1 A 4 0] fun {$ X} X>2 end}} % '', pois está esperando a variável A ter valor, dado que existe uma comparação lógica envolvida.

declare Out A
thread Out={Filter [5 1 A 4 0] fun {$ X} X>2 end} end
{Show Out} % _<optimized>, praticamente o mesmo caso anterior, pois a variável Out não foi computada completamente

declare Out A
thread Out={Filter [5 1 A 4 0] fun {$ X} X>2 end} end
{Delay 1000}
{Show Out} % 5|_<optimized>, aparece o 5| pois "deu tempo" a primeira operação ser feita na thread. Mas bloqueou de novo por conta que A não está ligado, e, assim, Out não foi computado por completo.

declare Out A
thread Out={Filter [5 1 A 4 0] fun {$ X} X>2 end} end
thread A=6 end
{Delay 1000}
{Show Out} % [5 6 4], funciona perfeitamente, pois a variável A fica ligada concorretemente a thread que executa o filtro. E, além disso, o comando delay faz "dar tempo" toda a computação de Out ser feita, mostrando no terminal corretamente.

/* QUESTÃO 10 - Basics of laziness. */
declare Three
fun lazy {Three}
    {Delay 1000}
    3
end

{Browse {Three}+0}
{Browse {Three}+0}
{Browse {Three}+0}

/*
Isso demora 3 * 1000ms pois cada chamada é independente da outra. O valor 3 não é guardado em nenhuma variável, para ser utilizada depois ( algo como programação dinâmica ).
*/

/* QUESTÃO 11 - Laziness and concurrency. */
declare
fun lazy {MakeX} {Browse x} {Delay 3000} 1 end
fun lazy {MakeY} {Browse y} {Delay 6000} 2 end
fun lazy {MakeZ} {Browse z} {Delay 9000} 3 end
X={MakeX}
Y={MakeY}
Z={MakeZ}

{Browse (X+Y)+Z} % 18 segundos
{Browse X+(Y+Z)} % 18 segundos
{Browse thread X+Y end + Z} % 18 segundos

/*
Por conta das funções serem lazy, ela só é "ativada" quando realmente é necessária, como no caso de operações aritméticas.
Assim, cada variável ( X, Y e Z ) tem um "tempo de criação", por conta do comando delay.
Mas, apesar disso, o tempo total para cada tipo de organização é o mesmo.
*/

/* QUESTÃO 13 - Laziness and monolithic functions. ?? */
declare
fun lazy {Reverse1 S}
    fun {Rev S R}
        case S of nil then R
        [] X|S2 then {Rev S2 X|R} end
        end
    in 
    {Rev S nil}
end

declare
fun lazy {Reverse2 S}
    fun lazy {Rev S R}
        case S of nil then R
        [] X|S2 then {Rev S2 X|R} end
        end
    in {Rev S nil}
end

/*
Ambas funções produzem o mesmo resultado, uma lista invertida.
Porém, as formas como são produzidas são um pouco diferentes entre si.
Na primeira função, apenas a função externa é lazy, então essencialmente apenas "o primeiro elemento é lazy", pois ao chamar a função Rev, que não é lazy, ela vai até o final. Portanto, a função Reverse1 não é verdadeiramente lazy.

Na segunda função, ambas partes são lazy, então a reversão acontece passo a passo, quando requisitada.

No entanto, para produzir uma lista invertida é necessário percorrer ela toda ( função monolítica ).
*/

/* QUESTÃO 14 - Laziness and iterative computation. ?? */
declare
fun lazy {LAppend As Bs}
    case As
    of nil then Bs
    [] A|Ar then A|{LAppend Ar Bs}
    end
end

/*
...
*/

/* QUESTÃO 18 - Concurrency and exceptions. ?? */
declare
proc {TryFinally S1 S2}
    B Y in
    try {S1} B=false catch X then B=true Y=X end
    {S2}
    if B then raise Y end end
end

local U=1 V=2 in
    {TryFinally proc {$} thread {TryFinally proc {$} U=V end proc {$} {Browse bing} end} end end proc {$} {Browse bong} end}
end