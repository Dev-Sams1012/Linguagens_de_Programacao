/* QUESTÃO 01 - Free and bound identifiers. */

proc {P X}
    if X>0 then {P X-1} end
end

/* Em linguagem kernel fica: */

P = proc {$ X}
   if X>0 then {P X-1} end

/* P não está declarado (não há o comando Local).  Então todas as ocorrências de P são livres, incluindo a que está dentro da definição do procedimento. */

/* ******************************************************************************************************* */

/* QUESTÃO 02 - Contextual environment. */

declare MulByN N in
    N=3
    proc {MulByN X ?Y}
        Y=N*X
end

/* O procedimento carrega o "n" do seu contexto léxico, independente se há alguma outra variável
    com identificador == n em outro ambiente */

/* Exemplo 1: */
declare MulByN N in
   N=3
   proc {MulByN X ?Y}
      Y = N*X
end

local A B in
    A=10
    {MulByN A B}
    {Browse B}
end

/* Exemplo 2: */
declare MulByN N in
   N=3
   proc {MulByN X ?Y}
      Y = N*X
end

local A B N in
    A=10
    N=1000
    {MulByN A B}
    {Browse B} 
end

/* ******************************************************************************************************* */

/* QUESTÃO 04 - The if and case statements. */

/* caso geral do if - em termos de case */
case X
of true then S1
[] false S2
end

/* caso geral do case - em termos do if */
if {Label X} == label then
   if {Arity X} == [f1 ... fn] then
      local X1 = X.f1 ... Xn = X.fn in
         S1
      end
   else S2 end
else S2 end

/* ******************************************************************************************************* */

/* QUESTÃO 05 - The case statement. */

declare Test
proc {Test X}
   case X
   of a|Z then {Browse 'case'(1)}
   [] f(a) then {Browse 'case'(2)}
   [] Y|Z andthen Y==Z then {Browse 'case'(3)}
   [] Y|Z then {Browse 'case'(4)}
   [] f(Y) then {Browse 'case'(5)}
   else {Browse 'case'(6)} end
end
 
{Test [b c a]} /* 4 */
{Test f(b(3))} /* 5 */
{Test f(a)}    /* 2 */
{Test f(a(3))} /* 5 */
{Test f(d)}    /* 5 */
{Test [a b c]} /* 1 */
{Test [c a b]} /* 4 */
{Test a|a}     /* 1 */
{Test '|'(a b c)} /* 6 */

/* ******************************************************************************************************* */

/* QUESTÃO 07 - Lexically scoped closures. */

declare Max3 Max5
proc {SpecialMax Value ?SMax}
   fun {SMax X} 
      if X>Value then X else Value end
   end
end
{SpecialMax 3 Max3} 
{SpecialMax 5 Max5}

{Browse [{Max3 4} {Max5 4}]} /* [4 5] */

/* ******************************************************************************************************* */

/* QUESTÃO 08 - Control abstraction. */

declare AndThen
fun {AndThen BP1 BP2}
    if {BP1} then {BP2} else false end
end

/* (a) give the same result as <expression>1 andthen <expression>2? Does it avoid the
evaluation of <expression>2 in the same situations? 
    
Sim, pois ele "chama" a BP2 se e somente se BP1 tiver valor lógico verdadeiro, agindo exatamente como o operador andthen.
*/

/* (b) */

declare OrElse
fun {OrElse BP1 BP2}
    if {BP1} then true else {BP2} end
end

/* ******************************************************************************************************* */

/* QUESTÃO 09 - Tail recursion. */

local Sum1 Sum2 in
   fun {Sum1 N}
      if N==0 then 0 else N+{Sum1 N-1} end
   end

   fun {Sum2 N S}
      if N==0 then S else {Sum2 N-1 N+S} end
   end
end

/* (a) */
declare Sum1 
Sum1 = proc {$ N ?S}
   if N == 0 then S = 0
   else NProx Ret in
      NProx = N-1
      {Sum1 NProx Ret}
      S = N + Ret /* há um "passo" após a chamada recursiva. */
   end
end

declare Sum2
Sum2 = proc {$ N S ?Sn}
   if N == 0 then Sn = S
   else NProx Acc in
      NProx = N-1
      Acc = N+S
      {Sum2 NProx Acc Sn} /* a chamada recursiva é o último "passo". */
   end
end

/* (b) */
/* A pilha de Sum1 acumula N posições, pois precisa ir aguardando os próximos valores, e após isso, desempilhando e somando. */

/* A pilha de Sum2 acumula apenas uma posição ( constante ), pois a variável acumuladora cumpre o papel do "resultado local". */

/* (c) */
declare Sum1 Sum2
   fun {Sum1 N}
      if N==0 then 0 else N+{Sum1 N-1} end
   end

   fun {Sum2 N S}
      if N==0 then S else {Sum2 N-1 N+S} end
   end

{Browse {Sum1 100000000} } /* Stack Overflow */
{Browse {Sum2 100000000 0} }


/* ******************************************************************************************************* */

/* QUESTÃO 10 - Expansion into kernel syntax. */

fun {SMerge Xs Ys}
   case Xs#Ys
   of nil#Ys then Ys
   [] Xs#nil then Xs
   [] (X|Xr)#(Y|Yr) then
      if X=<Y then X|{SMerge Xr Ys}
      else Y|{SMerge Xs Yr} end
   end
end

SMerge = proc {$ Xs Ys ?S}
   case Xs of nil then S = Ys
   else
      case Ys of nil then S = Xs
      else
         case Xs of X|Xr then
            case Ys of Y|Yr then
               if X=<Y then
                  local Mid in
                     S = X|Mid
                     {SMerge Xr Ys Mid}
                  end
               else
                  local Mid in
                     S = Y|Mid
                     {SMerge Xs Yr Mid}
                  end
               end
            end
         end
      end
   end
end

/* ******************************************************************************************************* */

/* QUESTÃO 11 - Mutual recursion. */
declare IsEven IsOdd
fun {IsEven X}
   if X==0 then true else {IsOdd X-1} end
end

fun {IsOdd X}
   if X==0 then false else {IsEven X-1} end
end

/* A pilha se mantém constante, pois a chamada recursiva é o último passo. Praticamente são duas "recursões pela cauda", uma para cada função. */