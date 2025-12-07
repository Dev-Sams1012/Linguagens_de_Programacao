declare
[LogicalGates] = {Module.link ['Trabalho02/LogicalGates.ozf']}
[Circuits] = {Module.link ['Trabalho02/DigitalCircuits.ozf']}

local C in
   C = {Circuits.bitComparator [0] [1]} % 0#0#1 - pois o primeiro bit é menor que o segundo.
   {Browse C}
end

local S Cin in
   S  = {LogicalGates.xorG [1 1 0] [1 0 1]}
   Cin = {LogicalGates.andG [1 1 0] [1 0 1]}
   {Browse S#Cin} % [0 1 1]#[1 0 0] - definição do meio somador, usando portas lógicas básicas.
end

local A in
   A = {Circuits.halfAdder [1 1 0] [1 0 1]}
   {Browse A} % [0 1 1]#[1 0 0] - usando o meio somador encapsulado.
end

local B in
   B = {Circuits.fullAdder [1 1 0] [1 0 1] [0 0 0]}
   {Browse B} % [0 1 1]#[1 0 0] - usando o somador completo encapsulado ( feito com base no meio somador )
end

local M in
   M = {Circuits.mux2 [1] [0] [1]} 
   {Browse M} % [0] - multiplexador. Nesse caso, passa energia apenas no primeiro canal, mas o canal setado para saída é o segundo.
end

local D in
   D = {Circuits.demux1 [1] [1]}
   {Browse D} % [0]#[1] - demultiplexador, passa energia e vai pro segundo canal de saída.
end

