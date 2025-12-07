functor
export
   andG:AndG
   orG:OrG
   nandG:NandG
   norG:NorG
   xorG:XorG
   notG:NotGate
define

    fun {CheckBit X}
        if X==0 orelse X==1 then X
        else
            raise error('Valor não é bit (0 ou 1)') end
        end
    end

    fun {GateMaker F}
    fun {$ Xs Ys}
        fun {GateLoop Xs Ys}
            case Xs#Ys of
                (X|Xr)#(Y|Yr) then B1 B2 in
                    B1 = {CheckBit X}
                    B2 = {CheckBit Y}
                    {F B1 B2} | {GateLoop Xr Yr}
                [] nil#nil then
                    nil
            else
                raise error('Listas de tamanhos diferentes') end
            end
        end
    in
        thread {GateLoop Xs Ys} end
    end
    end

    AndG  = {GateMaker fun {$ X Y} X*Y end}
    OrG   = {GateMaker fun {$ X Y} X+Y-X*Y end}
    NandG = {GateMaker fun {$ X Y} 1-X*Y end}
    NorG  = {GateMaker fun {$ X Y} 1-X-Y+X*Y end}
    XorG  = {GateMaker fun {$ X Y} X+Y-2*X*Y end}

    fun {NotGate Xs}
        case Xs of
            nil then nil
            [] X|Xr then B in
                B = {CheckBit X}
                (1-B)|{NotGate Xr}
        end
    end

end