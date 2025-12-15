module LogicGatesHs
  ( Signal
  , andGate
  , orGate
  , nandGate
  , norGate
  , xorGate
  , notGate
  ) where


type Bit    = Int
type Signal = [Bit]

checkBit :: Bit -> Bit
checkBit x
  | x == 0 || x == 1 = x
  | otherwise = error "Valor não é bit (0 ou 1)"

-- Função de criação de portas lógicas
gateMaker :: (Bit -> Bit -> Bit) -> Signal -> Signal -> Signal
gateMaker f xs ys = zipWith (\x y -> f (checkBit x) (checkBit y)) xs ys

-- AND
andGate :: Signal -> Signal -> Signal
andGate = gateMaker (\x y -> x * y)

-- OR
orGate :: Signal -> Signal -> Signal
orGate = gateMaker (\x y -> x + y - x * y)

-- NAND
nandGate :: Signal -> Signal -> Signal
nandGate = gateMaker (\x y -> 1 - x * y)

-- NOR
norGate :: Signal -> Signal -> Signal
norGate = gateMaker (\x y -> 1 - x - y + x * y)

-- XOR
xorGate :: Signal -> Signal -> Signal
xorGate = gateMaker (\x y -> x + y - 2 * x * y)

-- NOT
notGate :: Signal -> Signal
notGate [] = []
notGate (x:xs) = let b = checkBit x in (1 - b) : notGate xs