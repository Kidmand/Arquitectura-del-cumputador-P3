module maindec(
    input logic [10:0] Op,
    input logic ExtIRQ, reset,
    output logic Reg2Loc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ERet, Exc, BReg,
    output logic [3:0] EStatus,
    output logic [1:0] ALUSrc,
    output logic [1:0] ALUOp);

    logic [12:0] storage_signals [0:7] = '{
        13'b0_00_0_1_0_0_0_10_0_0_0, // R-format
        13'b0_01_1_1_1_0_0_00_0_0_0, // LDUR
        13'b1_01_0_0_0_1_0_00_0_0_0, // STUR
        13'b1_00_0_0_0_0_1_01_0_0_0, // CBZ
        13'b0_00_0_0_0_0_1_01_1_0_0, // ERET
        13'b1_10_0_1_0_0_0_01_0_0_0, // MRS
        13'b0_00_0_0_0_0_1_01_0_1_0, // BR
        13'b0_00_0_0_0_0_0_00_0_0_1  // Invalid OpCode
    }; // NotAnInstr esta como último bit de outputs_signals.

    logic NotAnInstr; // Señal interna
    logic [12:0] out;
    assign {Reg2Loc,    // 1b
            ALUSrc,     // 2b
            MemtoReg,   // 1b
            RegWrite,   // 1b
            MemRead,    // 1b
            MemWrite,   // 1b
            Branch,     // 1b
            ALUOp,      // 2b
            ERet,       // 1b
            BReg,       // 1b
            NotAnInstr  // 1b
            } = out;
    assign Exc = ExtIRQ | NotAnInstr;

    always_comb begin
        if (reset === 1) begin
            {out, EStatus} = '0;
        end
        else
            if (ExtIRQ === 0) begin
                casez (Op)
                    // TYPE R
                    11'b100_0101_1000,
                    11'b110_0101_1000,
                    11'b100_0101_0000,
                    11'b101_0101_0000: {out, EStatus} = {storage_signals[0], 4'b0000};
                    // LDUR
                    11'b111_1100_0010: {out, EStatus} = {storage_signals[1], 4'b0000};
                    // STUR
                    11'b111_1100_0000: {out, EStatus} = {storage_signals[2], 4'b0000};
                    // CBZ
                    11'b101_1010_0???: {out, EStatus} = {storage_signals[3], 4'b0000};
                    // ERET
                    11'b110_1011_0100: {out, EStatus} = {storage_signals[4], 4'b0000};
                    // MRS
                    11'b110_1010_1001: {out, EStatus} = {storage_signals[5], 4'b0000};
                    // BR
                    11'b110_1011_0000: {out, EStatus} = {storage_signals[6], 4'b0000};
                    default: {out, EStatus} = {storage_signals[7], 4'b0010}; // Invalid OpCode
                endcase
            end
            else begin
                out = {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead,
                    MemWrite, Branch, ALUOp, ERet, NotAnInstr};
                EStatus = 4'b0001;
            end
        end
endmodule
