functor
import
    LogicalGates at 'LogicalGates.ozf'
export
   halfAdder:HalfAdder
   fullAdder:FullAdder
   mux2:Mux2
   demux1:Demux1
   bitComparator:BitComparator
define

    fun {HalfAdder X Y}
        S  = {LogicalGates.xorG X Y}
        Cin = {LogicalGates.andG X Y}
    in
        S#Cin
    end

    fun {FullAdder X Y Cin}
        S1#C1 = {HalfAdder X Y}
        S2#C2 = {HalfAdder S1 Cin}
        Cout = {LogicalGates.orG C1 C2}
    in
        S2#Cout
    end

    fun {Mux2 X Y S}
        NotS = {LogicalGates.notG S}
        Xand = {LogicalGates.andG X NotS}
        YandS = {LogicalGates.andG Y S}
    in
        {LogicalGates.orG Xand YandS}
    end

    fun {Demux1 X S}
        NotS = {LogicalGates.notG S}
        Y0 = {LogicalGates.andG X NotS}
        Y1 = {LogicalGates.andG X S}
    in
        Y0#Y1
    end

    fun {BitComparator A B}
        NotA = {LogicalGates.notG A}
        NotB = {LogicalGates.notG B}
        AGT = {LogicalGates.andG A NotB}
        ALT = {LogicalGates.andG NotA B}
        AEQ = {LogicalGates.orG {LogicalGates.andG A B} {LogicalGates.andG NotA NotB}}
   in
        AGT#AEQ#ALT
   end


end