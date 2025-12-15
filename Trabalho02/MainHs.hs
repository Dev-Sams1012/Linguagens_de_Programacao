module Main where

import LogicGatesHs
import DigitalCircuitsHs


main :: IO ()
main = do
  -- Bit comparator
  let c = bitComparator [0] [1]
  print c
  -- esperado: ([0],[0],[1])

  -- Half-adder "manual" usando portas lógicas
  let s   = xorGate [1,1,0] [1,0,1]
      cin = andGate [1,1,0] [1,0,1]
  print (s, cin)
  -- esperado: ([0,1,1],[1,0,0])

  -- Half-adder encapsulado
  let a = halfAdder [1,1,0] [1,0,1]
  print a
  -- esperado: ([0,1,1],[1,0,0])

  -- Full-adder encapsulado
  let b = fullAdder [1,1,0] [1,0,1] [0,0,0]
  print b
  -- esperado: ([0,1,1],[1,0,0])

  -- MUX 2:1
  let m = mux2 [1] [0] [1]
  print m
  -- esperado: [0]

  -- DEMUX 1:2
  let d = demux1 [1] [1]
  print d
  -- esperado: ([0],[1])
