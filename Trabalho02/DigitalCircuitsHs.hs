module DigitalCircuitsHs
  ( halfAdder
  , fullAdder
  , mux2
  , demux1
  , bitComparator
  ) where

import LogicalGatesHs

halfAdder :: Signal -> Signal -> (Signal, Signal)
halfAdder x y =
  let s   = xorGate x y
      cin = andGate x y
  in (s, cin)

fullAdder :: Signal -> Signal -> Signal -> (Signal, Signal)
fullAdder x y cin =
  let (s1, c1) = halfAdder x y
      (s2, c2) = halfAdder s1 cin
      cout     = orGate c1 c2
  in (s2, cout)

mux2 :: Signal -> Signal -> Signal -> Signal
mux2 x y s =
  let notS = notGate s
      xAnd = andGate x notS
      yAnd = andGate y s
  in orGate xAnd yAnd

demux1 :: Signal -> Signal -> (Signal, Signal)
demux1 x s =
  let notS = notGate s
      y0   = andGate x notS
      y1   = andGate x s
  in (y0, y1)

bitComparator :: Signal -> Signal -> (Signal, Signal, Signal)
bitComparator a b =
  let notA = notGate a
      notB = notGate b

      aGT  = andGate a notB
      aLT  = andGate notA b
      aEQ  = orGate (andGate a b)
                     (andGate notA notB)
  in (aGT, aEQ, aLT)