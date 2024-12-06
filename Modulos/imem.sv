// INSTRUCTION MEMORY

module imem #(parameter N=32)
             (input logic [6:0] addr,
              output logic [N-1:0] q);

    logic [N-1:0] ROM [0:127];
    initial
    begin
        ROM  = '{default:'0};
        ROM [0:29] ='{32'h8b1e03c9,
32'h8b040129,
32'h8b1f03ea,
32'h8b1f03eb,
32'hf800014b,
32'h8b08014a,
32'h8b01016b,
32'hcb010129,
32'hb4000049,
32'hb4ffff7f,
32'hcb0a014a,
32'hcb0d01ad,
32'h8b0f014c,
32'hb40000ec,
32'hf840014e,
32'h8b0e01ad,
32'h8b08014a,
32'hcb01018c,
32'hb400004c,
32'hb4ffff7f,
32'hf800014d,
32'hcb0e01ce,
32'h8b1f022f,
32'hb40000af,
32'h8b1001ce,
32'hcb0101ef,
32'hb400004f,
32'hb4ffffbf,
32'hf800000e,
32'hb400001f};

ROM [54:70] ='{32'hd530200c,
32'hcb01018e,
32'hb400006e,
32'hcb02018e,
32'hb40000ae,
32'hf84003aa,
32'h8b01014a,
32'hf80003aa,
32'hd69f03e0,
32'hf84003cb,
32'h8b01016b,
32'hf80003cb,
32'hd530100d,
32'h8b0401ad,
32'hd61f01a0,
32'h00000000,
32'h00000000};

    end
    assign q = ROM[addr];
endmodule
