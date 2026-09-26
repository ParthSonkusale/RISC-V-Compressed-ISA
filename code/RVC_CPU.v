module RVC_CPU(
    input clk,
    input rst,
    input [15:0] Instr,
 
    output [15:0] Result
);
 
wire [4:0] rd;
wire [4:0] rs1;
wire [4:0] rs2;
wire RegWrite;
wire ALUSrc, UseSp, ISCmv;
wire [2:0] ALUCtrl;
wire [15:0] ImmExt;
wire MemWrite;
wire MemtoReg;
 
Datapath datapath(
    clk, rst, ALUCtrl, rd, rs1, rs2, RegWrite, ALUSrc,
    ISCmv, ImmExt, UseSp, MemWrite, MemtoReg, Result
);
 
Decoder decoder(
    Instr, rd, rs1, rs2, RegWrite, ALUSrc, ISCmv, ImmExt, UseSp,
    ALUCtrl, MemWrite, MemtoReg
);
 
endmodule