/* QUESTÃO 01 - Absolute value of real numbers. */

declare Abs
fun {Abs X} if X<0 then ~X else X end end

{Browse {Abs ~5.3}}

/* Essa função não funciona, pois a comparação de tipos está incorreta, dado que queremos o valor absoluto de números reais. Para numéros inteiros, funciona. */

/* Para corrigir isso, basta fazer: */

declare Abs
fun {Abs X} if X<0.0 then ~X else X end end

{Browse {Abs ~5.3}}

/* QUESTÃO 02 - Cube roots. *

declare Cbrt
fun {Cbrt X}
    fun {CbrtIter Guess}
        fun {Improve}
            (X/(Guess*Guess) + 2.0*Guess) / 3.0
        end
        fun {GoodEnough}
            {Abs (X-Guess*Guess*Guess)}/X < 0.00001
        end
    in
        if {GoodEnough} then Guess
        else
            {CbrtIter {Improve}}
        end
    end
    Guess=1.0
in
    {CbrtIter Guess}
end

{Browse {Cbrt 27.0}}     

/* QUESTÃO 03 - The half-interval method. */

declare
fun {HalfInterval F A B}
   fun {Iter A B}
      local Mid in
         Mid = (A + B) / 2.0
         if {Abs (B - A)} < 0.00001 then Mid
         elseif {F Mid} == 0.0 then Mid
         elseif ({F A} * {F Mid}) < 0.0 then {Iter A Mid}
         else
            {Iter Mid B}
         end
      end
   end
in
    {Iter A B}
end

declare
fun {Square X} X*X - 2.0 end
{Browse {HalfInterval Square 1.0 2.0}}

/* QUESTÃO 04 - Iterative factorial. */

declare
fun {IterFact N}
    fun {Loop N Acc}
        if N == 0 then Acc
        else {Loop N-1 N*Acc}
        end
    end
in
    {Loop N 1}
end

{Browse {IterFact 5}}

/* QUESTÃO 05 - An iterative SumList. */
declare
fun {IterSumList L}
    fun {LoopListSum L Acc}
        case L
        of nil then Acc
        [] X|Y then {LoopListSum Y Acc+X}
        end
    end
in
    {LoopListSum L 0}
end

{Browse {IterSumList [1 3 5 7 9 11]}}

/* QUESTÃO 07 - Another append function. */

fun {Append Ls Ms}
    case Ms
    of nil then Ls
    [] X|Mr then {Append {Append Ls [X]} Mr}
    end
end

/* Isso não funciona, num exemplo bem básico:

{Append [1 2] [3]}
de fato, a segunda lista não é vazia, então:
{Append { Append [1 2] [3]} nil}

que leva a uma chamada infinita de Append, pois a segunda lista nunca chega a ser nil...

*/

/* QUESTÃO 08 - An iterative append. */

/* O objetivo é criar um append, mas que não se utilize do comportamento dataflow, diferente deste, que utiliza desse comportamento: */
fun {Append Xs Ys}
    case Xs
    of nil then Ys
    [] X|Xr then X|{Append Xr Ys}
    end
end

/* Uma sugestão é fazer um append q recebe uma lista reversa e uma lista comum, e assim fazer um append sem a necessidade do comportamento dataflow */

declare
fun {Append Xs Ys}
    fun {Reverse Xs}
        fun {ReverseIter Xs Acc}
	        case Xs
	        of nil then Acc
	        [] X|Xr then {ReverseIter Xr X|Acc} end
        end
   in
      {ReverseIter Xs nil}
   end
   fun {ReverseAppendIter Xs Ys}
        case Xs
        of nil then Ys
        [] X|Xr then {ReverseAppendIter Xr X|Ys} end
   end
in
   {ReverseAppendIter {Reverse Xs} Ys}
end

{Browse {Append [1 2 3] [4 5 6]}}

/* QUESTÃO 10 - Checking if something is a list. */

/* Isso funciona, pois a verificação é feita por meio do casamento de padrão. */
declare
fun {Leaf X}
    case X
    of _|_ then false
    else true end
end

/* Isso não funciona, pois é como se eu estivesse comparando duas variáveis não ligadas ( cabeça e cauda ), e, por conta do comportamento dataflow, o programa fica esperando os valores das variáveis. */
declare
fun {Leaf X}
    X \= (_|_) 
end

{Browse {Leaf [1 2 3]}} 

/* QUESTÃO 11 - Limitations of difference lists */

fun {AppendD D1 D2}
   S1#E1=D1
   S2#E2=D2
in
   E1=S2
   S1#E2
end

/* Por definição, uma lista diferença tem o seguinte formato:

d1 | d2 | ... | S1 # S1
onde S é uma variável livre que representa o final da lista. Por exemplo, ao aplicarmos a operação de append em listas diferença, temos que a variável livre S1 é unificada com o primeiro termo da segunda lista diferença. E assim, a primeira lista é dita "destruida", pois a variável livre S1 deixa de ser livre, fazendo com que a lista diferença perca sua característica de lista diferença.

*/

/* QUESTÃO 14 - FIFO queues. */

declare
fun {NewQueue}
    X in q(0 X X)
end

fun {Insert Q X}
    case Q
    of q(N S E) then E1 in 
        E=X|E1
        q(N+1 S E1)
    end
end

fun {Delete Q X}
    case Q
    of q(N S E) then S1 in 
        S=X|S1 
        q(N-1 S1 E) 
    end
end

fun {IsEmpty Q}
    case Q
    of q(N S E) then N==0
    end
end

declare Q X Q1 Q2
Q = {NewQueue}
Q1 = {Delete Q X}
{Browse {IsEmpty Q1}}
Q2 = {Insert Q1 10}
{Browse X}
{Browse {IsEmpty Q2}}

/* a) Ao fazer isso, Q1 se torna uma nova fila com -1 elementos, e quando se adiciona um elemento, a variável livre X é ligada a tal valor adicionado, e logo em seguida a fila fica vazia novamente. */

declare
fun {IsEmpty Q}
    case Q
    of q(N S E) then S == E
    end
end

Q = {NewQueue}
Q1 = {Insert Q 10}
{Browse {IsEmpty Q1}}

/* b) Considerando o comportamento dataflow, quando a fila é criada, ambas variáveis são não ligadas, mas são "a mesma variável". Porém, ao realizar operações como Insert e Delete, que alteram sua estrutura, e, por sua vez, as variáves não ligadas das listas diferenças são diferentes entre si. Assim, a comparação S == E ficará esperando, pois as variáveis são diferentes e uma não está ligada. */

/* QUESTÃO 15 - Quicksort. */

declare
fun {QuickSort L}
    proc {Sort L ?S ?T}  
        case L
        of nil then S = T
        [] Pivot|Rest then
            local Small Big in
                {Partition Rest Pivot Small Big}
                local S1 T1 S2 T2 in
                    {Sort Small S1 T1}  
                    {Sort Big S2 T2}
                    S = S1
                    T1 = Pivot|S2
                    T = T2
                end
            end
        end
    end
   
    proc {Partition L Pivot ?Small ?Big}
        case L
        of nil then
            Small=nil 
            Big=nil
        [] X|Xr then Sr Br in
            {Partition Xr Pivot Sr Br}
            if X < Pivot then
                Small=X|Sr 
                Big=Br
            else 
                Small=Sr 
                Big=X|Br 
            end
        end
    end
   
   S T
in
   {Sort L S T}
   S
end

{Browse {QuickSort [10 5 1 -33 8 2 7 4]}}


/* QUESTÃO 16 - Tail-recursive convolution. */

declare
fun {Convolve Xs Ys}
    fun {Reverse L}
        fun {ReverseIter L Acc}
            case L
            of nil then Acc
            [] X|Xr then {ReverseIter Xr X|Acc}
            end
        end
    in
        {ReverseIter L nil}
    end
   
    proc {ConvolveIter Xs Ys ?Res}
        case Xs
        of nil then Res = nil
        [] X1|Xr then
            case Ys
            of nil then Res = nil
            [] Y1|Yr then Rs in
                Res = X1#Y1|Rs
                {ConvolveIter Xr Yr Rs}
            end
        end
    end
   
    Result
in
    {ConvolveIter Xs {Reverse Ys} Result}
    Result
end

{Browse {Convolve [1 2 3] [4 5 6]}} 