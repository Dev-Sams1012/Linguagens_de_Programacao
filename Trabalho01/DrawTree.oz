/* Essa é uma versão modificada do arquivo original de Peter Van Roy, disponibilizado no site oficial do Livro-texto. */

declare
fun {AddXY Tree}
   case Tree
   of tree(left:L right:R ...) then
      {Adjoin Tree tree(x:_ y:_ left:{AddXY L} right:{AddXY R})}
   [] leaf then
      leaf
   end
end        

Scale=40

proc {DepthFirst Tree Level LeftLimit RootX RightLimit}
   case Tree
   of tree(x:X y:Y left:leaf right:leaf ...) then
      X = LeftLimit
      Y = Scale * Level
      RootX = X
      RightLimit = X
   [] tree(x:X y:Y left:L right:leaf ...) then
      LocalRootX LocalRightLimit
   in
      {DepthFirst L (Level+1) LeftLimit LocalRootX LocalRightLimit}
      X = LocalRootX
      Y = Scale * Level
      RootX = X
      RightLimit = LocalRightLimit
   [] tree(x:X y:Y left:leaf right:R ...) then
      LocalRootX LocalRightLimit
   in
      {DepthFirst R (Level+1) LeftLimit LocalRootX LocalRightLimit}
      X = LocalRootX
      Y = Scale * Level
      RootX = X
      RightLimit = LocalRightLimit
   [] tree(x:X y:Y left:L right:R ...) then
      LRootX LRightLimit RRootX RRightLimit
   in
      {DepthFirst L (Level+1) LeftLimit LRootX LRightLimit}
      {DepthFirst R (Level+1) (LRightLimit + Scale) RRootX RRightLimit}
      X = (LRootX + RRootX) div 2
      Y = Scale * Level
      RootX = X
      RightLimit = RRightLimit
   end
end

Tree = tree(key:a val:111
     left:tree(key:b val:55
               left:tree(key:x val:100
                         left:tree(key:z val:56 left:leaf right:leaf)
                         right:tree(key:w val:23 left:leaf right:leaf))
               right:tree(key:y val:105 left:leaf
                          right:tree(key:r val:77 left:leaf right:leaf)))
     right:tree(key:c val:123
                left:tree(key:d val:119
                          left:tree(key:g val:44 left:leaf right:leaf)
                          right:tree(key:h val:50
                                     left:tree(key:i val:5 left:leaf right:leaf)
                                     right:tree(key:j val:6 left:leaf right:leaf)))
                right:tree(key:e val:133 left:leaf right:leaf)))

Tree2 = {AddXY Tree}
{DepthFirst Tree2 1 Scale _ _} 
{Browse Tree2}