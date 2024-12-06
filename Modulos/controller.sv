// CONTROLLER

module controller(input logic [10:0] instr,
                        input logic ExtIRQ, reset, ExcAck,
                        output logic [1:0] AluSrc,
                        output logic [3:0] AluControl, EStatus,
                        output logic reg2loc, regWrite,Branch,
                                memtoReg, memRead, memWrite, ERet, Exc, ExtIAck, BReg);

    logic [1:0] AluOp_s;

    maindec     decPpal     (.Op(instr),
                            .ExtIRQ(ExtIRQ),
                            .reset(reset),
                            .Reg2Loc(reg2loc),
                            .ALUSrc(AluSrc),
                            .MemtoReg(memtoReg),
                            .RegWrite(regWrite),
                            .MemRead(memRead),
                            .MemWrite(memWrite),
                            .Branch(Branch),
                            .ALUOp(AluOp_s),
                            .ERet(ERet),
                            .Exc(Exc),
                            .BReg(BReg),
                            .EStatus(EStatus));


    aludec     decAlu     (.funct(instr),
                            .aluop(AluOp_s),
                            .alucontrol(AluControl));

    assign ExtIAck = ExcAck & ExtIRQ;
endmodule
