module RVC_CPU(
    input clk,
    input rst,
    input [15:0] Instr,
 
    output [15:0] PC,
    output [15:0] Result
);
 
wire [4:0] rd,rs2,rs1;
wire RegWrite,Jal,PCScr;
wire ALUSrc, UseSp, ISCmv;
wire [2:0] ALUCtrl;
wire [15:0] ImmExt;
wire MemWrite,MemtoReg;
 
Datapath datapath(
    clk, rst, ALUCtrl, rd, rs1, rs2, RegWrite, ALUSrc,
    ISCmv, PCScr, Jal, ImmExt, UseSp, MemWrite, MemtoReg, PC,Result
);
 
Decoder decoder(
    Instr, rd, rs1, rs2, RegWrite, ALUSrc, ISCmv, ImmExt, UseSp,
    ALUCtrl, MemWrite, MemtoReg,Jal,PCSrc
);
 
endmodule